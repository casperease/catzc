<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
    folder: private
    name: test-test-run-over-budget
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
    test: automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
    cites:
      - ADR-AUTO-FAILFAST#7
      - ADR-AUTO-TEST#44
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
