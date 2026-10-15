<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-XPLAT#6
---
#>

<#
.SYNOPSIS
    Derives a completed run's verdict — the Passed/Failed result and its one-line reason — from the run facts.
.DESCRIPTION
    The closing banner and the failure throw both read this one result, so the reason wording lives in one place.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md#comment1)
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
.PARAMETER BudgetFailure
    Whether a devbox run outlasted its whole-run budget (tests.run_seconds), which fails it.
.PARAMETER RunBudgetSeconds
    The whole-run budget, for the budget-failure wording.
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

        [switch] $BudgetFailure,

        [int] $RunBudgetSeconds,

        [int] $PassedCount,

        [int] $SkippedCount,

        [double] $DurationSeconds
    )

    # A timing-only or budget-only failure fails the run without changing $RunResult, so the verdict folds it in.
    $result = if ($RunResult -ne 'Passed' -or $TimingFailure -or $BudgetFailure) {
        'Failed'
    }
    else {
        'Passed'
    }

    # Invariant culture keeps the duration identical on any devbox: a da-DK box would render a comma against CI's dot.
    # [comment:2](/docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md#comment2)
    $seconds = [math]::Round($DurationSeconds, 1).ToString([System.Globalization.CultureInfo]::InvariantCulture)
    $summary = if ($result -eq 'Passed') {
        "$PassedCount passed, $SkippedCount skipped in ${seconds}s"
    }
    elseif ($FailedCount -gt 0) {
        "$FailedCount test(s) failed"
    }
    elseif ($FailedShardLabels.Count -gt 0) {
        "worker(s) $($FailedShardLabels -join ', ') reported a failed run with no failed tests (a container/discovery error — see the output above)"
    }
    elseif ($BudgetFailure) {
        "the run took ${seconds}s, over its ${RunBudgetSeconds}s budget (tests.run_seconds in timeouts.yml) — make the slowest files faster (out/test-automation/durations.json records each file's time)"
    }
    else {
        $timingViolationCount = @(Get-TestTimingViolation -Rows $Rows -Limits $Limits).Count
        "$timingViolationCount test(s) exceeded their level time limit (-EnforceTimings)"
    }

    @{ Result = $result; Summary = $summary }
}
