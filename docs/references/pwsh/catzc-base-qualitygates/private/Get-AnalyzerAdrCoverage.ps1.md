# pwsh/Catzc.Base.QualityGates/private/Get-AnalyzerAdrCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The (ADR rule id -> enforcing analyzer) rows from configs/analyzer-adr-map.yml — the 'pssa-rule' enforcer kind for the rule-coverage report.

### description

Flattens the analyzer-adr-map config into one row per (analyzer rule, ADR id) pairing, each tagged Kind = 'pssa-rule'. A PSScriptAnalyzer
rule listed in the map is credited as mechanically enforcing its ADR rule(s) on every run, because the L2 Test-ScriptAnalyzer test runs
inside Test-Automation — so the rule-coverage report (Write-TestAutomationRuleCoverage) counts these alongside the 'pester-test' enforcers
it derives from tagged tests. AdrId is the [index](../../../../adr/index.md) '#' citation form, matching the test tags, so the two enforcer
kinds union on AdrId directly. See the test-automation ADR.

### outputs

`[pscustomobject]` one per mapping: AdrId (e.g. 'ADR-AUTO-NOPWD#1'), Enforcer (the analyzer rule name), Kind ('pssa-rule').
