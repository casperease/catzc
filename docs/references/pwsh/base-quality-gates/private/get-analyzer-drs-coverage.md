# pwsh/Base.QualityGates/private/Get-AnalyzerDrsCoverage.ps1

Reads the analyzer-to-rule map and returns one row per analyzer rule and DRS rule it enforces. The rule-coverage report counts these rows
beside the enforcers it derives from tagged tests, because the analyzer runs inside every full test run.

## help

### synopsis

The (DRS rule id -> enforcing analyzer) rows from configs/analyzer-drs-map.yml — the 'pssa-rule' enforcer kind for the rule-coverage report.

### description

Flattens the analyzer-drs-map config into one row per (analyzer rule, record id) pairing, each tagged Kind = 'pssa-rule'. A
PSScriptAnalyzer rule listed in the map is credited as mechanically enforcing its DRS rule(s) on every run, because the L2 Test-ScriptAnalyzer test runs
inside Test-Automation — so the rule-coverage report (Write-TestAutomationRuleCoverage) counts these alongside the 'pester-test' enforcers
it derives from tagged tests. RecordId is the [index](../../../../drs/index.md) '#' citation form, matching the test tags, so the two
enforcer kinds union on RecordId directly. See the test-automation record.

### outputs

`[pscustomobject]` one per mapping: RecordId (e.g. 'ADR-AUTO-NOPWD-NOWORKINGDIRECTORYPATHS'), Enforcer (the analyzer rule name), Kind
('pssa-rule').
