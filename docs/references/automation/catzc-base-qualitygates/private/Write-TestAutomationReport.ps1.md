---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md
    kind: comment-page
    body_sha: "79036b4b8ddc"
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$csvRows = @($Rows |`.

```text
tests.csv — one row per test, slowest first (the report's columns; failure detail stays in summary.md).
Rules carries the ADR provenance citations, so tests.csv is the backtrack table: filter it by a rule to
find every test that enforces it.
```

## comment:7

Above `$now = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss',...`.

```text
InvariantCulture: a bare ':' in a .NET date format is the culture's time-separator placeholder, which
renders as '.' under some locales (see the cross-platform ADR). Force literal colons.
```
