<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1
    folder: private
    name: get-script-analyzer-inputs
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    cites:
      - ADR-AUTO-CACHE#10
---
#>

function Get-ScriptAnalyzerInputs {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory)]
        [string] $RepositoryRoot,

        [Parameter(Mandatory)]
        [string] $SettingsPath
    )

    $codeRoot = Get-CatzcModulesRoot
    $inputs = [System.Collections.Generic.List[string]]::new()
    $inputs.Add($SettingsPath)
    foreach ($folder in (Join-Path $codeRoot '.scriptanalyzer'), (Join-Path $codeRoot '.vendor/PSScriptAnalyzer')) {
        if ([System.IO.Directory]::Exists($folder)) {
            $pattern = if ($folder -like '*.vendor*') {
                'PSScriptAnalyzer.psd1'
            }
            else {
                '*.ps*1'
            }
            # The rule files sit directly in .scriptanalyzer and the manifest one version folder into the vendored module.
            foreach ($file in @(Get-ChildPath $folder -File -Filter $pattern -Depth 3 -PruneVendor $false | Sort-Object)) {
                if ($file -notmatch '[\\/]tests[\\/]') {
                    $inputs.Add($file)
                }
            }
        }
    }
    $inputs.Add((Join-Path $RepositoryRoot 'automation/Catzc.Base.QualityGates/assets/english.txt.gz'))
    $inputs.Add((Join-Path $RepositoryRoot 'automation/Catzc.Base.QualityGates/types/SpellingOracle.cs'))
    $cspell = Join-Path $RepositoryRoot '.cspell'
    if ([System.IO.Directory]::Exists($cspell)) {
        foreach ($file in @([System.IO.Directory]::EnumerateFiles($cspell, '*.txt') | Sort-Object)) {
            $inputs.Add($file)
        }
    }
    , [string[]] $inputs.ToArray()
}
