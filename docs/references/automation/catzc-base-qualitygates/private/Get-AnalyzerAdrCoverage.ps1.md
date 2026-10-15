# docs/references/automation/catzc-base-qualitygates/private/Get-AnalyzerAdrCoverage.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-AnalyzerAdrCoverage.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Flattens the analyzer-adr-map config into one row per (analyzer rule, ADR id) pairing, each tagged
Kind = 'pssa-rule'. A PSScriptAnalyzer rule listed in the map is credited as mechanically enforcing its ADR
rule(s) on every run, because the L2 Test-ScriptAnalyzer test runs inside Test-Automation — so the
rule-coverage report (Write-TestAutomationRuleCoverage) counts these alongside the 'pester-test' enforcers
it derives from tagged tests. AdrId is the [index](/docs/adr/index.md) '#' citation form, matching the test tags, so
the two enforcer kinds union on AdrId directly. See the test-automation ADR.
```
