# pwsh/Base.QualityGates/private/Write-TestAutomationReport.ps1

Renders a human-readable run report, `summary.md` and `tests.csv`, from the run's row set.

## help

### synopsis

Renders a human-readable run report (summary.md + tests.csv) from the run's row set.

### description

Writes two files into $OutputFolder from the aggregated per-test rows (ConvertTo-TestAutomationRowSet):

- tests.csv : one row per test (ExpandedPath, Result, DurationMs, Level, Category, File, Line), slowest first.
- summary.md : run header + counts, the failures (with file:line and message), the slowest tests, and the over-limit timing violations (the
  same per-level rule the console prints).

Rows — not a live Pester object — are the input because parallel workers reduce their own results in-process and only the rows survive the
process boundary; counts are derived from the rows. The canonical machine artifacts (`results-shard-*.xml`) are written by Pester in the
workers; this adds the at-a-glance view. The limit map is passed in so there is a single source of truth.

### parameter `Rows`

The aggregated per-test rows (ConvertTo-TestAutomationRowSet output, merged across shards).

### parameter `OutputFolder`

The run directory the files are written into (created if missing).

### parameter `Level`

The -Level the run was invoked with (recorded in the header).

### parameter `RunResult`

The run's aggregate verdict ('Passed'/'Failed'), recorded in the header.

### parameter `DurationSeconds`

The run's wall-clock duration in seconds, recorded in the header.

### parameter `Limits`

Per-level millisecond limits keyed by tag (L0/L1/L2/L3) — the over-limit threshold per test level. Defaults to the `tests.level_ms` limits
in timeouts.yml (Get-TestTimeLimits).

### parameter `RunBudgetSeconds`

The budget for the whole run, in seconds; the header records the run against it (a devbox run over it fails,
[ADR-AUTO-TEST-DEVBOXRUNBUDGET](../../../../drs/automation/test-automation.md#rule-adr-auto-test-devboxrunbudget)). Defaults to
`tests.run_seconds` in timeouts.yml (Get-TestTimeLimits).

### parameter `SlowestCount`

How many slowest passed tests to list. Defaults to 20.

### parameter `TimingsEnforced`

Whether -EnforceTimings was set (annotates the over-limit section).

### parameter `Location`

Where the run executed — 'in-place', or the snapshot's provenance — recorded in the header when given.

## tests.csv

The file holds one row per test, slowest first, in the report's columns. Failure detail stays in `summary.md`. The Rules column carries the
ADR provenance citations, so `tests.csv` is the backtrack table: filtering it by a rule finds every test that enforces it.

## Timestamps

The timestamp is formatted with the invariant culture. A bare `:` in a .NET date format is the culture's time-separator placeholder, which
renders as `.` under some locales, so the format forces literal colons.
