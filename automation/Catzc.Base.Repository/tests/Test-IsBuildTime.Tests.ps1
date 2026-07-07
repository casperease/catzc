Describe 'Test-IsBuildTime' -Tag 'L0', 'logic' {

    AfterEach {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
    }

    It 'is false when the build flag is unset (the default — not build-time)' {
        Remove-Item Env:CATZC_BUILD_TIME -ErrorAction Ignore
        Test-IsBuildTime | Should -BeFalse
    }

    It 'is true when the build entry points have entered build-time' {
        $env:CATZC_BUILD_TIME = 'true'
        Test-IsBuildTime | Should -BeTrue
    }
}
