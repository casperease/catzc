# catzc:
#   path: automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
#   module: Catzc.Base.QualityGates
#   visibility: private

<#
.SYNOPSIS
    Whether a test run outlasted its whole-run budget in a way that fails it: a devbox run over tests.run_seconds.
.DESCRIPTION
    The budget is a roof never raised to make a run pass; a pipeline run is bounded by its stage limit instead.
    [ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44),
    [ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md#comment1)
.PARAMETER DurationSeconds
    The run's wall clock — its workers' run, as the run reports it.
.PARAMETER BudgetSeconds
    The whole-run budget (Get-TestTimeLimits RunSeconds, tests.run_seconds in timeouts.yml).
.OUTPUTS
    [bool] True when the run fails on its budget.
.EXAMPLE
    Test-TestRunOverBudget -DurationSeconds 201.3 -BudgetSeconds 180
#>
function Test-TestRunOverBudget {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [double] $DurationSeconds,

        [Parameter(Mandatory)]
        [int] $BudgetSeconds
    )

    if ((Test-IsRunningInPipeline) -or $DurationSeconds -le $BudgetSeconds) {
        return $false
    }
    Write-Message ('Run took {0:N1}s, over its {1}s budget (tests.run_seconds in timeouts.yml) — the run fails.' -f $DurationSeconds, $BudgetSeconds) -ForegroundColor Red
    $true
}
