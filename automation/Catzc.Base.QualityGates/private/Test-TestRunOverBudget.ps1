<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      test: automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
    adrs:
      - ADR-AUTO-FAILFAST#7
      - ADR-AUTO-TEST#44
  config:
    synopsis: 'Whether a test run outlasted its whole-run budget in a way that fails it: a devbox run over tests.run_seconds.'
    description: |-
      The whole-run budget fails a devbox run that outlasts it
      ([ADR-AUTO-TEST#44](/docs/adr/automation/test-automation.md#rule-adr-auto-test44)) — the time safeguard's fail-fast
      stance applied to the run itself ([ADR-AUTO-FAILFAST#7](/docs/adr/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast7)):
      a slow run is a defect to fix, not a wait to absorb, and the budget is a roof that is never raised to make a run
      pass. A pipeline run is bounded by its stage's own limit instead, so it never fails here. A failing run says so on the console,
      with its time and the budget.
    parameters:
      DurationSeconds: The run's wall clock — its workers' run, as the run reports it.
      BudgetSeconds: The whole-run budget (Get-TestTimeLimits RunSeconds, tests.run_seconds in timeouts.yml).
    outputs: '[bool] True when the run fails on its budget.'
    examples:
      - Test-TestRunOverBudget -DurationSeconds 201.3 -BudgetSeconds 180
---
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
