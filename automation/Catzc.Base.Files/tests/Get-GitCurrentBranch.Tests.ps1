Describe 'Get-GitCurrentBranch' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = "main `n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -eq 'git rev-parse --abbrev-ref HEAD' }
    }

    It 'returns the trimmed branch name' {
        Get-GitCurrentBranch | Should -Be 'main'
    }
}
