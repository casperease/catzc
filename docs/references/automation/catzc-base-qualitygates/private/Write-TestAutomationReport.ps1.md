---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md
    kind: comment-page
    body_sha: "32c8b6f05067"
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$csvRows = @($Rows |`, written with `#`.

```text
tests.csv — one row per test, slowest first (the report's columns; failure detail stays in summary.md).
Rules carries the ADR provenance citations, so tests.csv is the backtrack table: filter it by a rule to
find every test that enforces it.
```

## comment:2

Above `$now = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss',...`, written with `#`.

```text
InvariantCulture: a bare ':' in a .NET date format is the culture's time-separator placeholder, which
renders as '.' under some locales (see the cross-platform ADR). Force literal colons.
```
