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

        [string] $BudgetKey = 'tests.run_seconds',

        [int] $PassedCount,

        [int] $SkippedCount,

        [double] $DurationSeconds,

        [object] $Growth
    )

    # A timing-only or budget-only failure fails the run without changing $RunResult, so the verdict folds it in.
    $result = if ($RunResult -ne 'Passed' -or $TimingFailure -or $BudgetFailure) {
        'Failed'
    }
    else {
        'Passed'
    }

    # Invariant: a da-DK box would otherwise render '42,3s'.
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
        $overBudget = "the run took ${seconds}s, over its ${RunBudgetSeconds}s budget ($BudgetKey in timeouts.yml)"
        $makeFaster = "make the slowest files faster (out/test-automation/durations.json records each file's time)"
        if ($null -eq $Growth) {
            "$overBudget — $makeFaster"
        }
        else {
            $invariant = [System.Globalization.CultureInfo]::InvariantCulture
            $earlier = "against the last run under the budget ($([math]::Round($Growth.Seconds, 1).ToString($invariant))s, $($Growth.Run))"
            $grown = "the growth of $([math]::Round($Growth.GrowthSeconds, 1).ToString($invariant)) file-seconds"
            $top = "$($Growth.TopFile) +$([math]::Round($Growth.TopGrowthSeconds, 1).ToString($invariant))s"
            if ($Growth.Spread) {
                "$overBudget; $earlier $grown is spread over the files (top: $top), the mark of a cold run after an antivirus signature update: run it again before cutting anything"
            }
            else {
                "$overBudget; $earlier $grown is concentrated: $top — make it faster (out/test-automation/durations.json records each file's time)"
            }
        }
    }
    else {
        $timingViolationCount = @(Get-TestTimingViolation -Rows $Rows -Limits $Limits).Count
        "$timingViolationCount test(s) exceeded their level time limit (-EnforceTimings)"
    }

    @{ Result = $result; Summary = $summary }
}
