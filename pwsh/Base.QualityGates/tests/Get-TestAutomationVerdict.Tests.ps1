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
        $verdict.Summary |
            Should -BeLike 'the run took 201.3s, over its 180s budget (tests.run_seconds in timeouts.yml)*'
    }

    It 'names the budget key it is given in a budget-only failure' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -BudgetFailure -RunBudgetSeconds 60 -BudgetKey 'tests.widget_seconds' -DurationSeconds 90
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -BeLike 'the run took 90s, over its 60s budget (tests.widget_seconds in timeouts.yml)*'
    }

    It 'reads a budget failure whose growth is spread over the files as a cold run to run again' -Tag 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            $growth = [pscustomobject]@{
                Run = '20990101-000000'; Seconds = 235.33; GrowthSeconds = 75.04; GrownFiles = 14; TopFile = 'Get-Widget.Tests.ps1'; TopGrowthSeconds = 24.41
                Spread = $true
            }
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -BudgetFailure -RunBudgetSeconds 240 -DurationSeconds 248.53 -Growth $growth
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Be ('the run took 248.5s, over its 240s budget (tests.run_seconds in timeouts.yml); against the last complete run of this kind ' +
            '(235.3s, 20990101-000000) the growth of 75 file-seconds is spread over 14 files (top: Get-Widget.Tests.ps1 +24.4s), the mark of a cold run ' +
            'after an antivirus signature update: run it again before cutting anything')
    }

    It 'reads a budget failure whose growth is concentrated in one file as that file to make faster' -Tag 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            $growth = [pscustomobject]@{
                Run = '20990101-000000'; Seconds = 204.8; GrowthSeconds = 70.12; GrownFiles = 3; TopFile = 'Get-Gadget.Tests.ps1'; TopGrowthSeconds = 61.2
                Spread = $false
            }
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -BudgetFailure -RunBudgetSeconds 240 -DurationSeconds 251 -Growth $growth
        }
        $verdict.Result | Should -Be 'Failed'
        $verdict.Summary | Should -Be ('the run took 251s, over its 240s budget (tests.run_seconds in timeouts.yml); against the last complete run of this kind ' +
            '(204.8s, 20990101-000000) the growth of 70.1 file-seconds is concentrated: Get-Gadget.Tests.ps1 +61.2s — make it faster ' +
            "(out/test-automation/durations.json records each file's time)")
    }

    It 'keeps the slowest-files sentence when there is no earlier run to compare with' -Tag 'ADR-AUTO-TEST-DEVBOXRUNBUDGET' {
        $verdict = InModuleScope Catzc.Base.QualityGates {
            Get-TestAutomationVerdict -Rows @() -Limits @{} -RunResult 'Passed' -FailedCount 0 `
                -BudgetFailure -RunBudgetSeconds 240 -DurationSeconds 242.43 -Growth $null
        }
        $verdict.Summary | Should -Be ('the run took 242.4s, over its 240s budget (tests.run_seconds in timeouts.yml) — make the slowest files faster ' +
            "(out/test-automation/durations.json records each file's time)")
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
