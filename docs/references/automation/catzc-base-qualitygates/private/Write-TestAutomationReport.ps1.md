---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Write-TestAutomationReport.ps1.md
    kind: reference
    body_sha: "786526ae0061"
    adrs:
      - ADR-AUTO-TEST#44
---

# automation/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Writes two files into $OutputFolder from the aggregated per-test rows (ConvertTo-TestAutomationRowSet):
  - tests.csv   : one row per test (ExpandedPath, Result, DurationMs, Level, Category, File, Line),
                  slowest first.
  - summary.md  : run header + counts, the failures (with file:line and message), the slowest tests,
                  and the over-limit timing violations (the same per-level rule the console prints).
Rows — not a live Pester object — are the input because parallel workers reduce their own results
in-process and only the rows survive the process boundary; counts are derived from the rows. The
canonical machine artifacts (results-shard-*.xml) are written by Pester in the workers; this adds the
at-a-glance view. The limit map is passed in so there is a single source of truth.
```

## comment:2

Section `.PARAMETER Limits` of the comment-based help.

```text
Per-level millisecond limits keyed by tag (L0/L1/L2/L3) — the over-limit threshold per test level. Defaults to
the `tests.level_ms` limits in timeouts.yml (Get-TestTimeLimits).
```

## comment:3

Section `.PARAMETER RunBudgetSeconds` of the comment-based help.

```text
The budget for the whole run, in seconds; the header records the run against it (a devbox run over it fails,
[ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44)). Defaults to
`tests.run_seconds` in timeouts.yml (Get-TestTimeLimits).
```

## comment:4

Above `$csvRows = @($Rows |`.

```text
tests.csv — one row per test, slowest first (the report's columns; failure detail stays in summary.md).
Rules carries the ADR provenance citations, so tests.csv is the backtrack table: filter it by a rule to
find every test that enforces it.
```

## comment:5

Above `$now = [datetime]::Now.ToString('yyyy-MM-dd HH:mm:ss',...`.

```text
InvariantCulture: a bare ':' in a .NET date format is the culture's time-separator placeholder, which
renders as '.' under some locales (see the cross-platform ADR). Force literal colons.
```
