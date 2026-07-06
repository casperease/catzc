Describe 'Test-GitPathChanged' -Tag 'L0', 'logic' {
    It 'is true when git status reports an entry under the paths' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = ' M .sha-markers/automation.yml' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged '.sha-markers' | Should -BeTrue
    }

    It 'is false when the paths match HEAD (empty porcelain output)' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged '.sha-markers' | Should -BeFalse
    }

    It 'quotes every path into one pathspec-limited status call' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged '.sha-markers', 'automation/.compiled' | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git status --porcelain -- ".sha-markers" "automation/.compiled"'
        }
    }
}
