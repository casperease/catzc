<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1
    folder: private
    name: get-test-automation-verdict
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-TestAutomationVerdict.Tests.ps1
    adrs:
      - ADR-AUTO-XPLAT#6
  config:
    synopsis: Derives a completed run's verdict — the Passed/Failed result and its one-line reason — from the run facts.
    description: |-
      The single place that turns the aggregated run facts (the test verdict, the failed-test count, failed-shard
      labels, the timing verdict) into the two values the closing banner and the failure throw both consume: a
      'Passed'/'Failed' Result — a timing-only or budget-only failure reads Failed even though the test verdict
      passed — and a Summary reason: the counts-in-time on a pass, or the cause on a fail (failed tests, a failed
      shard with no failed test row, a devbox run over its whole-run budget, or an -EnforceTimings over-limit).
      Extracted from Test-Automation so the reason wording
      lives once and the orchestrator stays a single, readable responsibility.
    parameters:
      Rows: The run's aggregated per-test rows — the over-limit count is recomputed from these on the timing path.
      Limits: The per-level millisecond limits, for the over-limit count.
      RunResult: The test verdict ('Passed'/'Failed') from the rows, before folding in the timing verdict.
      FailedCount: The failed-test-row count.
      FailedShardLabels: Labels of shards that reported a failed run with no failed test row (a container/discovery error).
      TimingFailure: Whether -EnforceTimings failed the run on an over-limit test.
      BudgetFailure: Whether a devbox run outlasted its whole-run budget (tests.run_seconds), which fails it.
      RunBudgetSeconds: The whole-run budget, for the budget-failure wording.
      PassedCount: Passed-test count, for the pass summary wording.
      SkippedCount: Skipped-test count, for the pass summary wording.
      DurationSeconds: Wall-clock duration, for the pass summary wording.
    outputs: '[hashtable] @{ Result = ''Passed''|''Failed''; Summary = ''<one-line reason>'' }'
---
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
