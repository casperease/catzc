<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-CACHE#10
  config:
    synopsis: Every file besides the analyzed file itself that decides a PSScriptAnalyzer verdict.
    description: |-
      The analyzer's result cache keys each file on its SHA-256 and a stamp of these inputs
      ([ADR-AUTO-CACHE#10](/docs/adr/automation/caching.md#rule-adr-auto-cache10)), so this list must hold everything the
      analysis loads: the settings file; every file of the custom rules (automation/.scriptanalyzer, the settings'
      CustomRulePath); the vendored analyzer's module manifests, which name its version; and what the spelling rule's
      oracle reads — the English word list, the generated terminology dictionaries (.cspell/*.txt) and the oracle's own
      source. A rule that starts reading another file adds it here in the same change.
    parameters:
      RepositoryRoot: The repository root.
      SettingsPath: The analyzer settings file.
    outputs: '[string[]] Absolute paths, in a stable order.'
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
