# automation/Catzc.Base.QualityGates/private/Write-TestAutomationRuleCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the ADR-rule enforcement coverage report (rule-coverage.md + rule-coverage.csv) from a run's rows.

### description

Builds the (ADR rule -> enforcers) map and writes it as a report artifact. An enforcer is one of two kinds, both run in the same
Test-Automation invocation: a 'pester-test' (a test tagged with the rule's citation, read from each row's Rules column) or a 'pssa-rule' (a
PSScriptAnalyzer rule mapped to the rule, from Get-AnalyzerAdrCoverage). Counting the analyzer rules is what makes the "uncovered" list
honest — a rule like [ADR-AUTO-NOPWD](../../../../adr/automation/never-depend-on-pwd.md) reads as covered because its custom analyzer fails
the build on every run.

A pure function of its inputs (no config or ADR reads of its own), so the caller passes the rule universe and the analyzer coverage in.
Report-only: it never throws on an uncovered rule — many rules are enforced structurally or by review, so absence of a mechanical enforcer
is information, not a defect. The 'by test' figures reflect the tests in THIS run's scope (a -Modules/-Level filter narrows the rows).

### parameter `Rows`

The aggregated per-test rows (ConvertTo-TestAutomationRowSet), each carrying ExpandedPath and the ';'-joined Rules citations.

### parameter `AnalyzerCoverage`

The (AdrId, Enforcer, Kind='pssa-rule') rows from Get-AnalyzerAdrCoverage. AdrId is '#' citation form.

### parameter `AllRuleIds`

Every declared ADR rule id in '#' citation form (Get-CatsAdrRuleIds, ':'->'#') — the coverage universe.

### parameter `OutputFolder`

The run directory the two files are written into (created if missing).

## comment:1

Above `$testEnforcers = @{}`, written with `#`.

```text
Enforcers per rule id, split by kind. Sets so a rule cited by many tests, or an analyzer listed twice,
counts each enforcer once.
```
