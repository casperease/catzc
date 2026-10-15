<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-AnalyzerAdrCoverage.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-NOPWD#1
---
#>

<#
.SYNOPSIS
    The (ADR rule id -> enforcing analyzer) rows from configs/analyzer-adr-map.yml — the 'pssa-rule' enforcer
    kind for the rule-coverage report.
.DESCRIPTION
    A mapped rule counts as enforcing its ADR on every run, since the L2 analyzer test runs inside Test-Automation.
.OUTPUTS
    [pscustomobject] one per mapping: AdrId (e.g. 'ADR-AUTO-NOPWD#1'), Enforcer (the analyzer rule name), Kind
    ('pssa-rule').
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
