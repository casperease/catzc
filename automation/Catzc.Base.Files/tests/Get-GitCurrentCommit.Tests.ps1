Describe 'Get-GitCurrentCommit' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "abc1234def5678  `n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -eq 'git rev-parse HEAD' }
    }

    It 'returns the trimmed commit hash from git rev-parse HEAD' {
        Get-GitCurrentCommit | Should -Be 'abc1234def5678'
    }

    It 'invokes git rev-parse HEAD via Invoke-Executable' {
        Get-GitCurrentCommit | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -ParameterFilter { $Command -eq 'git rev-parse HEAD' }
    }
}
