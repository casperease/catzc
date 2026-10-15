<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
    kind: gate-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-NOPWD#1
      - ADR-AUTO-TEST#35
---
#>

<#
.SYNOPSIS
    Analyzes the automation PowerShell with PSScriptAnalyzer and writes a report under out/.
.DESCRIPTION
    Uses the rule set from the loaded code root, so a local run matches what the editor and CI see.
.PARAMETER Path
    The default is the catzc source tree, so it needs the source mode; an explicit -Path works in either run mode.
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-script-analyzer.
.PARAMETER NoCache
    Analyze every file, ignoring the result cache (which is still refreshed).
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
    # The settings ship inside the code tree, so they resolve from the code root, not the repository root.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment3)
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $settingsPath

    # Same coverage as the L2 analyzer test: module root, private, tests and the infrastructure folders.
    # [comment:4](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment4)
    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
            # Resolving against the current directory would make results depend on where the caller stood.
            # [comment:5](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment5)
            $full = if ([System.IO.Path]::IsPathRooted($item)) {
                $item
            }
            else {
                Join-Path $root $item
            }
            if (Test-Path -LiteralPath $full -PathType Container) {
                # Scripts reach four levels below automation (module, tests, types, file); vendored modules are pruned.
                foreach ($script in Get-ChildPath $full -File -Filter '*.ps1', '*.psm1' -Depth 4) {
                    $files.Add($script)
                }
            }
            else {
                Assert-PathExist $full -PathType Leaf
                $files.Add([System.IO.Path]::GetFullPath($full))
            }
        }
    }
    else {
        # Shared with the L2 analyzer test so the two cannot drift; generated manifests are excluded.
        # [comment:6](/docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md#comment6)
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

    # Sharding turns about 90 seconds of silence, which reads as a hang, into a short run with live progress.
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
