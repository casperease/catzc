---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationRuleCoverage.ps1.md
    kind: comment-page
    body_sha: c67842edd0b3
    adrs: []
    links: []
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationRuleCoverage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the (ADR rule -> enforcers) map and writes it as a report artifact. An enforcer is one of two kinds,
both run in the same Test-Automation invocation: a 'pester-test' (a test tagged with the rule's citation,
read from each row's Rules column) or a 'pssa-rule' (a PSScriptAnalyzer rule mapped to the rule, from
Get-AnalyzerAdrCoverage). Counting the analyzer rules is what makes the "uncovered" list honest — a rule
like [ADR-AUTO-NOPWD](/docs/adr/automation/never-depend-on-pwd.md) reads as covered because its custom analyzer
fails the build on every run.

A pure function of its inputs (no config or ADR reads of its own), so the caller passes the rule universe
and the analyzer coverage in. Report-only: it never throws on an uncovered rule — many rules are enforced
structurally or by review, so absence of a mechanical enforcer is information, not a defect. The 'by test'
figures reflect the tests in THIS run's scope (a -Modules/-Level filter narrows the rows).
```

## comment:2

Section `.PARAMETER Rows` of the comment-based help.

```text
The aggregated per-test rows (ConvertTo-TestAutomationRowSet), each carrying ExpandedPath and the
';'-joined Rules citations.
```

## comment:3

Above `$testEnforcers = @{}`.

```text
Enforcers per rule id, split by kind. Sets so a rule cited by many tests, or an analyzer listed twice,
counts each enforcer once.
```
