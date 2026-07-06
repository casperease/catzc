Describe 'Write-TestAutomationTimingReport' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Write-Header -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Footer -ModuleName Catzc.Base.QualityGates { }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        $script:limits = @{ 'L0' = 400 }
        $script:overRow = [pscustomobject]@{ ExpandedPath = 'X.slow'; Result = 'Passed'; DurationMs = 900; Level = 'L0' }
        $script:okRow = [pscustomobject]@{ ExpandedPath = 'X.fast'; Result = 'Passed'; DurationMs = 10; Level = 'L0' }
    }

    It 'is silent and returns false when nothing is over its limit' {
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Rows = @($script:okRow); Limits = $script:limits } {
            param($Rows, $Limits)
            Write-TestAutomationTimingReport -Rows $Rows -Limits $Limits
        }
        $result | Should -BeFalse
        Should -Invoke Write-Header -ModuleName Catzc.Base.QualityGates -Times 0 -Exactly
    }

    It 'reports violations but returns false without -EnforceTimings (report-only)' {
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Rows = @($script:overRow); Limits = $script:limits } {
            param($Rows, $Limits)
            Write-TestAutomationTimingReport -Rows $Rows -Limits $Limits
        }
        $result | Should -BeFalse
        Should -Invoke Write-Header -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -like '*report-only*' }
    }

    It 'returns true (the run fails) with -EnforceTimings' {
        $result = InModuleScope Catzc.Base.QualityGates -Parameters @{ Rows = @($script:overRow); Limits = $script:limits } {
            param($Rows, $Limits)
            Write-TestAutomationTimingReport -Rows $Rows -Limits $Limits -EnforceTimings
        }
        $result | Should -BeTrue
        Should -Invoke Write-Header -ModuleName Catzc.Base.QualityGates -Times 1 -ParameterFilter { $Message -notlike '*report-only*' }
    }
}
