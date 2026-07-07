Describe 'Test-GitPathChanged' -Tag 'L0', 'logic' {
    It 'is true when git status reports an entry under the paths' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = ' M automation/.compiled/Catzc.Types.abc12345.dll' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged 'automation/.compiled' | Should -BeTrue
    }

    It 'is false when the paths match HEAD (empty porcelain output)' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged 'automation/.compiled' | Should -BeFalse
    }

    It 'quotes every path into one pathspec-limited status call' {
        Mock Invoke-Executable {
            [pscustomobject]@{ ExitCode = 0; Output = '' }
        } -ModuleName Catzc.Base.Files
        Test-GitPathChanged 'automation/.compiled', 'out' | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git status --porcelain -- "automation/.compiled" "out"'
        }
    }
}
