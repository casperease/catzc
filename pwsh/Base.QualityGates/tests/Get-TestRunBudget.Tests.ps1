Describe 'Get-TestRunBudget' -Tag 'L0', 'logic', 'ADR-AUTO-TEST-POSTBUILDTAG' {
    BeforeAll {
        $script:limits = [pscustomobject]@{ RunSeconds = 111; PostBuildSeconds = 222 }
    }

    It 'answers the run roof and its key for a source run' {
        $budget = InModuleScope Catzc.Base.QualityGates -Parameters @{ Limits = $script:limits } {
            param($Limits)
            Get-TestRunBudget -TimeLimits $Limits
        }
        $budget.Seconds | Should -Be 111
        $budget.Key | Should -Be 'tests.run_seconds'
    }

    It 'answers the post-build roof and its key for a post-build run' {
        $budget = InModuleScope Catzc.Base.QualityGates -Parameters @{ Limits = $script:limits } {
            param($Limits)
            Get-TestRunBudget -TimeLimits $Limits -PostBuild
        }
        $budget.Seconds | Should -Be 222
        $budget.Key | Should -Be 'tests.post_build_seconds'
    }
}
