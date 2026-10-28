# pwsh/Base.QualityGates/private/Write-TestAutomationArtifacts.ps1

Writes a run's report artifacts and the skip report. It is best-effort and never masks the run outcome: each artifact has its own `try`, and
a failure prints a warning.

## help

### synopsis

Writes a run's report artifacts and the skip report — best-effort, never masking the run outcome.

### description

Persists summary.md + tests.csv beside the per-shard results (Write-TestAutomationReport), points latest.txt at the run, renders the
end-of-run skip report (Write-TestAutomationSkipReport), and writes the DRS rule-enforcement coverage (Write-TestAutomationRuleCoverage —
rule-coverage.md/.csv). Each part is try/catch-guarded independently: a rendering error is reported as a yellow line and swallowed, so a
failing run still throws for its own reason, not a reporting one.

### parameter `Rows`

The run's aggregated per-test rows.

### parameter `RunDirectory`

The run's timestamped artifact directory.

### parameter `OutputFolder`

The report base directory (latest.txt lands here).

### parameter `MaxLevel`

The run's maximum tier (report metadata).

### parameter `Limits`

The per-level duration limits (report metadata).

### parameter `RunResult`

The aggregate verdict ('Passed'/'Failed').

### parameter `DurationSeconds`

The run's wall-clock duration.

### parameter `EnforceTimings`

Whether timing violations fail the run (report metadata).

### parameter `MinLevel`

The run's minimum tier (skip-report scope).

### parameter `Category`

The run's category (skip-report scope).

### parameter `Location`

Where the run executed (report metadata) — 'in-place', or the snapshot's provenance.

## Report

The run report, `summary.md` and `tests.csv`, is written beside the per-shard results. It is written before any throw, so a failing run
still produces it.

## Skip report

The final section lists what was skipped, a self-skip with its reason, and what was not run because the run's tier and category scope
excluded it.

## Rule coverage

The DRS rule-enforcement coverage is report-only, under the same best-effort rule. It unions the enforcers of tagged tests (each row's Rules
column) with the enforcers among the analyzer rules (Get-AnalyzerDrsCoverage) over the full rule universe. A plain assignment receives the
comma-wrapped getter intact, and the `:` of a registry id becomes `#` so it matches the tags.
