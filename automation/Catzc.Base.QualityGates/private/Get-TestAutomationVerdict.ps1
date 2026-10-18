<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-TestAutomationVerdict.ps1
    folder: private
    name: get-test-automation-verdict
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    page: docs/references/automation/catzc-base-qualitygates/private/Get-TestAutomationVerdict.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Get-TestAutomationVerdict.Tests.ps1
    cites:
      - ADR-AUTO-XPLAT#6
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
