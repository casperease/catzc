<#
---
catzc:
  immutable:
    with_body_sha: e488b38f56d9
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1
    docs: "[Get-AnalyzerAdrCoverage.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-AnalyzerAdrCoverage.ps1.md)"
    cites:
      - ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS
---
#>

function Get-AnalyzerAdrCoverage {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param()

    $config = Get-Config -Config analyzer-adr-map
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
