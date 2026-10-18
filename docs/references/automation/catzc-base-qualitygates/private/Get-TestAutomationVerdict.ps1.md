# automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives a completed run's verdict — the Passed/Failed result and its one-line reason — from the run facts.

### description

The single place that turns the aggregated run facts (the test verdict, the failed-test count, failed-shard labels, the timing verdict) into
the two values the closing banner and the failure throw both consume: a 'Passed'/'Failed' Result — a timing-only or budget-only failure
reads Failed even though the test verdict passed — and a Summary reason: the counts-in-time on a pass, or the cause on a fail (failed tests,
a failed shard with no failed test row, a devbox run over its whole-run budget, or an -EnforceTimings over-limit). Extracted from
Test-Automation so the reason wording lives once and the orchestrator stays a single, readable responsibility.

### parameter Rows

The run's aggregated per-test rows — the over-limit count is recomputed from these on the timing path.

### parameter Limits

The per-level millisecond limits, for the over-limit count.

### parameter RunResult

The test verdict ('Passed'/'Failed') from the rows, before folding in the timing verdict.

### parameter FailedCount

The failed-test-row count.

### parameter FailedShardLabels

Labels of shards that reported a failed run with no failed test row (a container/discovery error).

### parameter TimingFailure

Whether -EnforceTimings failed the run on an over-limit test.

### parameter BudgetFailure

Whether a devbox run outlasted its whole-run budget (tests.run_seconds), which fails it.

### parameter RunBudgetSeconds

The whole-run budget, for the budget-failure wording.

### parameter PassedCount

Passed-test count, for the pass summary wording.

### parameter SkippedCount

Skipped-test count, for the pass summary wording.

### parameter DurationSeconds

Wall-clock duration, for the pass summary wording.

### outputs

`[hashtable]` @{ Result = 'Passed'|'Failed'; Summary = '`<one-line reason>`' }

## comment:1

Above `$seconds = [math]::Round($DurationSeconds,...`, written with `#`.

```text
Invariant so the duration reads the same on any devbox culture
([ADR-AUTO-XPLAT#6](/docs/adr/automation/cross-platform.md#rule-adr-auto-xplat6)) — a da-DK box would
otherwise render '42,3s' and diverge from CI's '42.3s'.
```
