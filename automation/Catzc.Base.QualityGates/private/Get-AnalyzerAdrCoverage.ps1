<#
.SYNOPSIS
    The (ADR rule id -> enforcing analyzer) rows from configs/analyzer-adr-map.yml — the 'pssa-rule' enforcer
    kind for the rule-coverage report.
.DESCRIPTION
    Flattens the analyzer-adr-map config into one row per (analyzer rule, ADR id) pairing, each tagged
    Kind = 'pssa-rule'. A PSScriptAnalyzer rule listed in the map is credited as mechanically enforcing its ADR
    rule(s) on every run, because the L2 PSScriptAnalyzer gate runs inside Test-Automation — so the
    rule-coverage report (Write-TestAutomationRuleCoverage) counts these alongside the 'pester-test' enforcers
    it derives from tagged tests. AdrId is the docs/adr/index.md '#' citation form, matching the test tags, so
    the two enforcer kinds union on AdrId directly. See the test-automation ADR.
.OUTPUTS
    [pscustomobject] one per mapping: AdrId (e.g. 'ADR-NOPWD#1'), Enforcer (the analyzer rule name), Kind
    ('pssa-rule').
#>
function Get-AnalyzerAdrCoverage {
    [CmdletBinding()]
    [OutputType([object[]])]
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
