<#
---
catzc:
  immutable:
    with_body_sha: "8e58b272e2dc"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerDrsCoverage.Tests.ps1
    docs: "[Get-AnalyzerDrsCoverage.ps1.md](docs/references/pwsh/catzc-base-quality-gates/private/Get-AnalyzerDrsCoverage.ps1.md)"
    cites:
      - ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS
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
