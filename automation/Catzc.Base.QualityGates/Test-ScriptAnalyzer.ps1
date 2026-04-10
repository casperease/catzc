<#
.SYNOPSIS
    Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report under out/.
.DESCRIPTION
    Runs PSScriptAnalyzer over the same automation file set the analyzer test covers (module root *.ps1,
    private/, tests/, and the .internal/.scriptanalyzer infrastructure folders), applying the single rule set at
    automation/.internal/assets/PSScriptAnalyzerSettings.psd1 — so the result matches what the editor and CI see.

    This is the interactive, report-style sibling of the L2 'PSScriptAnalyzer' Pester test
    (automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1): both shard the analysis across background
    processes (see Get-ScriptAnalyzerDiagnostics) so a full-tree run finishes in ~15-30s with live progress
    rather than ~90s of silence; this gate runs on demand and writes a readable report. It is also the verify
    counterpart to Format-Automation — Format-Automation FIXES the auto-fixable formatting, Test-ScriptAnalyzer
    only reports and never rewrites files.

    Mirrors Test-Markdownlint's reporting: each run writes a timestamped folder under out/test-scriptanalyzer/
    (scriptanalyzer.md), updates latest.txt, and prints the report path rather than dumping every diagnostic
    to the console. Throws when violations are found (so it can gate CI); -PassThru returns a result object.

    PSScriptAnalyzer is vendored under automation/.vendor — no install step is needed.
.PARAMETER Path
    One or more files or directories to analyze. Defaults to the canonical gated set (Get-AutomationSourceFiles):
    module root *.ps1, private/, tests/, the .internal and .scriptanalyzer infrastructure folders (bootstrap,
    TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config.
.PARAMETER OutputFolder
    Base directory for the run report. Each run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/). Defaults to <out>/test-scriptanalyzer.
.PARAMETER PassThru
    Return a result object ({ IssueCount, FileCount, ReportPath }) instead of throwing.
.EXAMPLE
    Test-ScriptAnalyzer
.EXAMPLE
    $result = Test-ScriptAnalyzer -PassThru
    $result.IssueCount
.EXAMPLE
    Test-ScriptAnalyzer -Path ./automation/Catzc.Base.QualityGates
    Analyze just one module.
#>
function Test-ScriptAnalyzer {
    [CmdletBinding()]
    [Alias('Test-Pssa')]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $settingsPath = Join-Path $root 'automation/.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $settingsPath

    # Resolve the file set — same coverage as Format-Automation and the L2 analyzer test (module root
    # *.ps1 non-test, private/, tests/ *.Tests.ps1, and the .internal/.scriptanalyzer infrastructure folders).
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            if (Test-Path -Path $item -PathType Container) {
                Get-ChildItem -Path $item -Recurse -Include '*.ps1', '*.psm1' -File |
                    ForEach-Object { $files.Add($_.FullName) }
            }
            else {
                $files.Add((Resolve-Path -Path $item).Path)
            }
        }
    }
    else {
        # The canonical gated set — shared with Format-Automation and the L2 analyzer test so they cannot
        # drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    # Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
    # serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
    Write-Message "Analyzing $($files.Count) PowerShell file(s) with PSScriptAnalyzer..."
    $diagnostics = @(Get-ScriptAnalyzerDiagnostics -Path $files -SettingsPath $settingsPath)

    $issueCount = $diagnostics.Count
    $fileCount = @($diagnostics | ForEach-Object { $_.ScriptPath } | Select-Object -Unique).Count

    # Resolve the run directory — a timestamped subfolder under the report base (mirrors Test-Markdownlint),
    # so each run's report is preserved and cleared with the rest of out/.
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-scriptanalyzer'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    # Write the markdown report — the diagnostics land here, not on the console. Paths are made
    # repo-relative so the report reads cleanly and is stable across machines.
    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# PSScriptAnalyzer report')
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    if ($issueCount -eq 0) {
        $lines.Add('- Result: no PSScriptAnalyzer violations')
    }
    else {
        $lines.Add("- Violations: $issueCount across $fileCount file(s)")
        $lines.Add('')
        $lines.Add('## Violations')
        $lines.Add('')
        foreach ($d in ($diagnostics | Sort-Object ScriptPath, Line, Column)) {
            $relPath = $d.ScriptPath
            if ($relPath -and $relPath.StartsWith($root)) {
                $relPath = $relPath.Substring($root.Length).TrimStart('\', '/') -replace '\\', '/'
            }
            $lines.Add("- ${relPath}:$($d.Line):$($d.Column) $($d.Severity) $($d.RuleName) $($d.Message)")
        }
    }
    Set-Content -Path (Join-Path $runDir 'scriptanalyzer.md') -Value $lines -Encoding utf8
    Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8

    # Console — one line per file with its violation count; full per-violation detail is saved in the report.
    if ($issueCount -eq 0) {
        Write-Message 'No PSScriptAnalyzer violations found.'
    }
    else {
        $perFile = $diagnostics |
            Group-Object -Property { [System.IO.Path]::GetFileName($_.ScriptPath) } |
            Sort-Object @{ Expression = 'Count'; Descending = $true }, Name
        foreach ($file in $perFile) {
            Write-Message ('{0}: {1}' -f $file.Name, $file.Count) -NoHeader
        }
        Write-Message "$issueCount PSScriptAnalyzer violation(s) across $fileCount file(s)."
    }
    Write-Message "PSScriptAnalyzer report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        return [pscustomobject]@{
            IssueCount = $issueCount
            FileCount  = $fileCount
            ReportPath = $runDir
        }
    }

    if ($issueCount -gt 0) {
        throw "Test-ScriptAnalyzer failed: $issueCount PSScriptAnalyzer violation(s) found — see $runDir"
    }
}
