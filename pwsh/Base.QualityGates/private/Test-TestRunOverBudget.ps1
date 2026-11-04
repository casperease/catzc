function Test-TestRunOverBudget {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [double] $DurationSeconds,

        [Parameter(Mandatory)]
        [int] $BudgetSeconds,

        [string] $BudgetKey = 'tests.run_seconds'
    )

    if ((Test-IsRunningInPipeline) -or $DurationSeconds -le $BudgetSeconds) {
        return $false
    }
    Write-Message ('Run took {0:N1}s, over its {1}s budget ({2} in timeouts.yml) — the run fails.' -f $DurationSeconds, $BudgetSeconds, $BudgetKey) -ForegroundColor Red
    $true
}
