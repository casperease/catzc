Describe 'Invoke-AtBuildTime' -Tag 'L0', 'logic' {

    AfterEach {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
    }

    It 'reports build-time inside the scope and restores the binding after' {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
        $inside = Invoke-AtBuildTime { Test-IsBuildTime }
        $inside | Should -BeTrue
        Test-IsBuildTime | Should -BeFalse            # restored to the default outside the scope
    }

    It 'restores the prior value even when the build work throws' {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
        { Invoke-AtBuildTime { throw 'boom' } } | Should -Throw
        Test-IsBuildTime | Should -BeFalse
    }

    It 'nests — an inner build leaves the outer scope still build-time' {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
        Invoke-AtBuildTime {
            Invoke-AtBuildTime { } | Out-Null
            Test-IsBuildTime | Should -BeTrue         # inner scope's finally restored to 'true', not unset
        }
    }

    It 'passes the script block output through' {
        Invoke-AtBuildTime { 42 } | Should -Be 42
    }
}
