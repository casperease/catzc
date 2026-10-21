<#
---
catzc:
  immutable:
    with_body_sha: f63557b18856
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
    docs: "[Test-TestRunOverBudget.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Test-TestRunOverBudget.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
      - ADR-AUTO-TEST-DEVBOXRUNBUDGET
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
