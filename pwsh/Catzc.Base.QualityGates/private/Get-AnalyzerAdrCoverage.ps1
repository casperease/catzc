<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-AnalyzerAdrCoverage.ps1
    folder: private
    name: get-analyzer-adr-coverage
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
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
