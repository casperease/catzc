Describe 'Get-TimeBinding' -Tag 'L0', 'logic' {

    It 'returns test-time when a test run is active' {
        Mock Test-IsTestTime { $true } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Get-TimeBinding } | Should -Be 'test-time'
    }

    It 'returns build-time when building and not testing' {
        Mock Test-IsTestTime { $false } -ModuleName Catzc.Base.Repository
        Mock Test-IsBuildTime { $true } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Get-TimeBinding } | Should -Be 'build-time'
    }

    It 'defaults to runtime (runtime for live)' {
        Mock Test-IsTestTime { $false } -ModuleName Catzc.Base.Repository
        Mock Test-IsBuildTime { $false } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Get-TimeBinding } | Should -Be 'runtime'
    }

    It 'prefers test-time over build-time (a build step under test is being verified, not shipped)' {
        Mock Test-IsTestTime { $true } -ModuleName Catzc.Base.Repository
        Mock Test-IsBuildTime { $true } -ModuleName Catzc.Base.Repository
        InModuleScope Catzc.Base.Repository { Get-TimeBinding } | Should -Be 'test-time'
    }
}
