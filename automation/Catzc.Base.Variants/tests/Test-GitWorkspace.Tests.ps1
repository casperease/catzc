Describe 'Test-GitWorkspace' -Tag 'L0', 'logic' {

    It 'returns true for -MainDirect when the repo is main-direct' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ git_workspace = 'main-direct' } }
        Test-GitWorkspace -MainDirect | Should -BeTrue
        Test-GitWorkspace -MainViaPr | Should -BeFalse
    }

    It 'returns true for -MainViaPr when the repo is main-via-pr' {
        Mock Get-Config -ModuleName Catzc.Base.Variants -ParameterFilter { $Config -eq 'variants' } { [ordered]@{ git_workspace = 'main-via-pr' } }
        Test-GitWorkspace -MainViaPr | Should -BeTrue
        Test-GitWorkspace -MainDirect | Should -BeFalse
    }

    It 'requires exactly one of -MainDirect / -MainViaPr' {
        { Test-GitWorkspace } | Should -Throw
        { Test-GitWorkspace -MainDirect -MainViaPr } | Should -Throw
    }
}
