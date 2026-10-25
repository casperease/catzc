<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-ScriptAnalyzer.ps1.md"
  warning: "Generated Header"
---
#>

function Test-ScriptAnalyzer {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    [Alias('Test-Pssa')]
    param(
        [Catzc.Base.Asserts.ValidatePathGiven()]
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $NoCache,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $settingsPath = [Catzc.Base.QualityGates.AnalyzerDrsMapConfig]::SettingsPath((Get-CatzcModulesRoot))
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
                # Scripts reach four levels below pwsh/ (module, tests, types, file); vendored modules are pruned.
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
        foreach ($f in (Get-ModuleSourceFile)) {
            $files.Add($f)
        }
    }

    # Third-party files are not authored here, so the analyzer never judges them; a file outside the repository is never third-party.
    $thirdParty = Get-GlobSet -Name 'third-party'
    $authored = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $files) {
        $relative = [System.IO.Path]::GetRelativePath($root, $file) -replace '\\', '/'
        if ($relative.StartsWith('..') -or -not $thirdParty.Matches($relative)) {
            $authored.Add($file)
        }
    }
    $files = $authored

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
