<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      source: automation/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
    adrs:
      - ADR-AUTO-TEST#44
---
#>

Describe 'Test-TestRunOverBudget' -Tag 'L0', 'logic', 'ADR-AUTO-TEST#44' {
    BeforeEach {
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $false }
    }

    It 'fails a devbox run over its budget, and names its time and the budget' {
        InModuleScope Catzc.Base.QualityGates { Test-TestRunOverBudget -DurationSeconds 201.26 -BudgetSeconds 180 } | Should -BeTrue
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 1 -Exactly -ParameterFilter {
            $Message -like 'Run took 201?3s, over its 180s budget (tests.run_seconds in timeouts.yml)*'
        }
    }

    It 'passes a devbox run at or under its budget, silently' {
        InModuleScope Catzc.Base.QualityGates { Test-TestRunOverBudget -DurationSeconds 180 -BudgetSeconds 180 } | Should -BeFalse
        InModuleScope Catzc.Base.QualityGates { Test-TestRunOverBudget -DurationSeconds 12.5 -BudgetSeconds 180 } | Should -BeFalse
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }

    It 'never fails a pipeline run, which its stage''s own limit bounds' {
        Mock Test-IsRunningInPipeline -ModuleName Catzc.Base.QualityGates { $true }
        InModuleScope Catzc.Base.QualityGates { Test-TestRunOverBudget -DurationSeconds 900 -BudgetSeconds 180 } | Should -BeFalse
        Should -Invoke Write-Message -ModuleName Catzc.Base.QualityGates -Times 0
    }
}
