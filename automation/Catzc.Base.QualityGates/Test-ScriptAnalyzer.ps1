<#
.SYNOPSIS
    Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report under out/.
.DESCRIPTION
    Runs PSScriptAnalyzer over the same automation file set the analyzer test covers (module root *.ps1, private/,...
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment1)
.PARAMETER Path
    One or more files or directories to analyze — absolute, or repository-root-relative (never resolved against $PWD).
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment2)
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
    Test-ScriptAnalyzer -Path automation/Catzc.Base.QualityGates
    Analyze just one module.
#>
function Test-ScriptAnalyzer {
    [CmdletBinding()]
    [Alias('Test-Pssa')]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $NoCache,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    # The one settings file ships inside the code tree, so it resolves from the code root.
    # [ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment3)
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $settingsPath

    # Resolve the file set — same coverage as the L2 analyzer test (module root *.ps1 non-test, private/, tests/...
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment4)
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            # A relative path is repository-relative, never $PWD-relative.
            # [ADR-AUTO-NOPWD#1](/docs/adr/automation/never-depend-on-pwd.md#rule-adr-auto-nopwd1)
            # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment5)
            $full = if ([System.IO.Path]::IsPathRooted($item)) {
                $item
            }
            else {
                Join-Path $root $item
            }
            if (Test-Path -LiteralPath $full -PathType Container) {
                Get-ChildItem -LiteralPath $full -Recurse -Include '*.ps1', '*.psm1' -File |
                    ForEach-Object { $files.Add($_.FullName) }
            }
            else {
                Assert-PathExist $full -PathType Leaf
                $files.Add([System.IO.Path]::GetFullPath($full))
            }
        }
    }
    else {
        # The canonical checked set — shared with the L2 analyzer test so they cannot drift.
        # [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment6)
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    # Analyze, sharded across background processes with live progress (Get-ScriptAnalyzerDiagnostics) — a serial pass...
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment7)
    Write-Message "Analyzing $($files.Count) PowerShell file(s) with PSScriptAnalyzer..."
    $diagnostics = @(Get-ScriptAnalyzerDiagnostics -Path $files -SettingsPath $settingsPath -NoCache:$NoCache)

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
