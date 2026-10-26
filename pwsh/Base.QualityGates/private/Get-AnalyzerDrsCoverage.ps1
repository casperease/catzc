<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-AnalyzerDrsCoverage.ps1.md"
  header: "generated"
---
#>

function Get-AnalyzerDrsCoverage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $config = Get-Config -Config analyzer-drs-map
    foreach ($analyzer in $config.analyzers.Keys) {
        foreach ($adrId in $config.analyzers[$analyzer]) {
            [pscustomobject]@{
                AdrId    = $adrId
                Enforcer = $analyzer
                Kind     = 'pssa-rule'
            }
        }
    }
}
