<#
.SYNOPSIS
    Derives a completed run's verdict — the Passed/Failed result and its one-line reason — from the run facts.
.DESCRIPTION
    The single place that turns the aggregated run facts (the test verdict, the failed-test count, failed-shard
    labels, the timing verdict) into the two values the closing banner and the failure throw both consume: a
    'Passed'/'Failed' Result — a timing-only failure reads Failed even though the test verdict passed — and a
    Summary reason: the counts-in-time on a pass, or the cause on a fail (failed tests, a failed shard with no
    failed test row, or an -EnforceTimings over-limit). Extracted from Test-Automation so the reason wording
    lives once and the orchestrator stays a single, readable responsibility.
.PARAMETER Rows
    The run's aggregated per-test rows — the over-limit count is recomputed from these on the timing path.
.PARAMETER Limits
    The per-level millisecond limits, for the over-limit count.
.PARAMETER RunResult
    The test verdict ('Passed'/'Failed') from the rows, before folding in the timing verdict.
.PARAMETER FailedCount
    The failed-test-row count.
.PARAMETER FailedShardLabels
    Labels of shards that reported a failed run with no failed test row (a container/discovery error).
.PARAMETER TimingFailure
    Whether -EnforceTimings failed the run on an over-limit test.
.PARAMETER PassedCount
    Passed-test count, for the pass summary wording.
.PARAMETER SkippedCount
    Skipped-test count, for the pass summary wording.
.PARAMETER DurationSeconds
    Wall-clock duration, for the pass summary wording.
.OUTPUTS
    [hashtable] @{ Result = 'Passed'|'Failed'; Summary = '<one-line reason>' }
#>
function Get-TestAutomationVerdict {
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [object[]] $Rows,

        [Parameter(Mandatory)]
        [hashtable] $Limits,

        [string] $RunResult,

        [int] $FailedCount,

        [string[]] $FailedShardLabels = @(),

        [switch] $TimingFailure,

        [int] $PassedCount,

        [int] $SkippedCount,

        [double] $DurationSeconds
    )

    # A timing-only failure fails the run without changing $RunResult, so the verdict folds it in.
    $result = if ($RunResult -ne 'Passed' -or $TimingFailure) {
        'Failed'
    }
    else {
        'Passed'
    }

    $summary = if ($result -eq 'Passed') {
        # Invariant so the duration reads the same on any devbox culture (ADR-AUTO-XPLAT:6) — a da-DK box would
        # otherwise render '42,3s' and diverge from CI's '42.3s'.
        $seconds = [math]::Round($DurationSeconds, 1).ToString([System.Globalization.CultureInfo]::InvariantCulture)
        "$PassedCount passed, $SkippedCount skipped in ${seconds}s"
    }
    elseif ($FailedCount -gt 0) {
        "$FailedCount test(s) failed"
    }
    elseif ($FailedShardLabels.Count -gt 0) {
        "worker(s) $($FailedShardLabels -join ', ') reported a failed run with no failed tests (a container/discovery error — see the output above)"
    }
    else {
        $timingViolationCount = @(Get-TestTimingViolation -Rows $Rows -Limits $Limits).Count
        "$timingViolationCount test(s) exceeded their level time limit (-EnforceTimings)"
    }

    @{ Result = $result; Summary = $summary }
}
