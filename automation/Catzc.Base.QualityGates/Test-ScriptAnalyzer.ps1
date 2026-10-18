<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
    name: test-script-analyzer
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Test-ScriptAnalyzer.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
    cites:
      - ADR-AUTO-ASSETDEP#1
      - ADR-AUTO-NOPWD#1
      - ADR-AUTO-TEST#35
---
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
    $settingsPath = Join-Path (Get-CatzcModulesRoot) '.internal/assets/PSScriptAnalyzerSettings.psd1'
    Assert-PathExist $settingsPath

    $files = [System.Collections.Generic.List[string]]::new()
    if ($Path) {
        foreach ($item in $Path) {
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
        foreach ($f in (Get-AutomationSourceFiles)) {
            $files.Add($f)
        }
    }

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
