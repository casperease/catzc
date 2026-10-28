# pwsh/Base.QualityGates/private/Write-TestAutomationRuleCoverage.ps1

Renders the DRS rule enforcement coverage report, `rule-coverage.md` and `rule-coverage.csv`, from a run's rows.

## help

### synopsis

Renders the DRS rule enforcement coverage report (rule-coverage.md + rule-coverage.csv) from a run's rows.

### description

Builds the (DRS rule -> enforcers) map and writes it as a report artifact. An enforcer is one of two kinds, both run in the same
Test-Automation invocation: a 'pester-test' (a test tagged with the rule's citation, read from each row's Rules column) or a 'pssa-rule' (a
PSScriptAnalyzer rule mapped to the rule, from Get-AnalyzerDrsCoverage). Counting the analyzer rules is what makes the "uncovered" list
honest — a rule like [ADR-AUTO-NOPWD](../../../../drs/automation/never-depend-on-pwd.md) reads as covered because its custom analyzer fails
the build on every run.

A pure function of its inputs (no config or DRS reads of its own), so the caller passes the rule universe and the analyzer coverage in.
Report-only: it never throws on an uncovered rule — many rules are enforced structurally or by review, so absence of a mechanical enforcer
is information, not a defect. The 'by test' figures reflect the tests in THIS run's scope (a -Modules/-Level filter narrows the rows).

### parameter `Rows`

The aggregated per-test rows (ConvertTo-TestAutomationRowSet), each carrying ExpandedPath and the ';'-joined Rules citations.

### parameter `AnalyzerCoverage`

The (RecordId, Enforcer, Kind='pssa-rule') rows from Get-AnalyzerDrsCoverage. RecordId is '#' citation form.

### parameter `AllRuleIds`

Every declared DRS rule id in '#' citation form (Get-DrsRuleIds, ':'->'#') — the coverage universe.

### parameter `OutputFolder`

The run directory the two files are written into (created if missing).

## Enforcers

Enforcers are collected per rule id and split by kind. They are sets, so a rule cited by many tests, or an analyzer listed twice, counts
each enforcer once.
