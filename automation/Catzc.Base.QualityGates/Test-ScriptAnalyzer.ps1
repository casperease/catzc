<#
.SYNOPSIS
    Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report under out/.
.DESCRIPTION
    Runs PSScriptAnalyzer over the same automation file set the analyzer test covers (module root *.ps1,
    private/, tests/, and the .internal/.scriptanalyzer infrastructure folders), applying the single rule set at
    .internal/assets/PSScriptAnalyzerSettings.psd1 under the loaded code root (Get-CatzcModulesRoot) — so the
    result matches what the editor and CI see.

    This is the interactive, report-style sibling of the L2 'PSScriptAnalyzer' Pester test
    (automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1): both shard the analysis across background
    processes (see Get-ScriptAnalyzerDiagnostics) so a full-tree run finishes in ~15-30s with live progress
    rather than ~90s of silence. It is also the verify counterpart to Format-Automation — Format-Automation FIXES
    the auto-fixable formatting, Test-ScriptAnalyzer only reports and never rewrites files.

    A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): every
    diagnostic ('<path>:<line>:<col> <severity> <rule> <message>', repository-relative) is an issue, and the gate
    ends through Write-QualityGateReport, which writes out/test-script-analyzer/, prints every issue, and throws
    once listing them all; -PassThru returns the result object instead.

    PSScriptAnalyzer is vendored under the code root's .vendor/ — no install step is needed.
.PARAMETER Path
    One or more files or directories to analyze. Defaults to the canonical checked set (Get-AutomationSourceFiles):
    module root *.ps1, private/, tests/, the .internal and .scriptanalyzer infrastructure folders (bootstrap,
    TestKit, custom analyzer rules, and their tests), the root importer.ps1, and authored .psd1 config. The
    default set is the catzc source tree, so it needs source mode; an explicit -Path works in either run mode.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-script-analyzer.
.PARAMETER PassThru
    Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount }) instead of throwing.
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
    # The one settings file ships inside the code tree, so it resolves from the code root
    # ([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
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
        # The canonical checked set — shared with Format-Automation and the L2 analyzer test so they cannot
        # drift. Includes the root importer.ps1 and authored .psd1 config; excludes generated manifests.
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    # Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a
    # serial pass is ~90s of silence and reads as a hang. The upfront message confirms work has started.
    Write-Message "Analyzing $($files.Count) PowerShell file(s) with PSScriptAnalyzer..."
    $diagnostics = @(Get-ScriptAnalyzerDiagnostics -Path $files -SettingsPath $settingsPath)

    # Paths are made repo-relative so the issues read cleanly and are stable across machines.
    $issues = @(foreach ($d in ($diagnostics | Sort-Object ScriptPath, Line, Column)) {
            $relPath = $d.ScriptPath
            if ($relPath -and $relPath.StartsWith($root)) {
                $relPath = $relPath.Substring($root.Length).TrimStart('\', '/') -replace '\\', '/'
            }
            "${relPath}:$($d.Line):$($d.Column) $($d.Severity) $($d.RuleName) $($d.Message)"
        })

    $facts = [ordered]@{
        FileCount = @($diagnostics | ForEach-Object { $_.ScriptPath } | Select-Object -Unique).Count
    }
    Write-QualityGateReport -Subject script-analyzer -Title Test-ScriptAnalyzer -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
