<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestAutomationVerdict.Tests.ps1
    folder: tests
    name: get-test-automation-verdict-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-TestAutomationVerdict' -Tag 'L0', 'logic' {
    It 'reads Passed with an invariant counts-in-time summary when nothing failed' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -PassedCount 812 -SkippedCount 14 -DurationSeconds 42.34
        }
        $verdict.Result | Should -Be 'Passed'
        $verdict.Summary | Should -Be '812 passed, 14 skipped in 42.3s'   # invariant dot, not a da-DK comma
    }

    It 'reads Failed and names the failed-test count' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Failed' -FailedCount 3 `
                -PassedCount 809 -SkippedCount 14 -DurationSeconds 42.3
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Be '3 test(s) failed'
    }

    It 'reads Failed and names a failed shard that produced no failed test row' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Failed' -FailedCount 0 `
                -FailedShardLabels @('shard-3') -DurationSeconds 1
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Match '^worker\(s\) shard-3 reported a failed run with no failed tests'
    }

    It 'folds a timing-only failure into a Failed verdict with the over-limit count' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            # The timing branch recomputes the count via Get-TestTimingViolation; mock it to two over-limit rows.
            Mock Get-TestTimingViolation { 'a', 'b' }
            Get-TestAutomationVerdict -Rows @() -Limits @{ L0 = 1 } -RunResult 'Passed' -FailedCount 0 `
                -TimingFailure -DurationSeconds 1
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Be '2 test(s) exceeded their level time limit (-EnforceTimings)'
    }

    It 'folds a budget-only failure into a Failed verdict that names the run time and the budget' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -BudgetFailure -RunBudgetSeconds 180 -PassedCount 5400 -SkippedCount 40 -DurationSeconds 201.26
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -BeLike 'the run took 201.3s, over its 180s budget (tests.run_seconds in timeouts.yml)*'
    }

    It 'names failed tests before the budget when both failed the run' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Failed' -FailedCount 2 `
                -BudgetFailure -RunBudgetSeconds 180 -DurationSeconds 201
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Be '2 test(s) failed'
    }
}
