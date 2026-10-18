Describe 'Invoke-GitCommit' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = ''; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -like 'git status --porcelain*' }
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = ''; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -like 'git add*' }
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = ''; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -like 'git commit*' }
        Mock Get-GitCurrentCommit { 'abc1234567890abcdef1234567890abcdef12345' } -ModuleName Catzc.Base.Files
    }

    It 'in dry-run, returns the planned add and commit commands and touches nothing' {
        $planned = Invoke-GitCommit -Path 'automation/.compiled', 'out' -Message 'sync' -DryRun
        $planned.Count | Should -Be 2
        $planned[0] | Should -Be 'git add -A -- "automation/.compiled" "out"'
        $planned[1] | Should -Be 'git commit -m "sync" -- "automation/.compiled" "out"'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }

    It 'returns nothing and does not commit when the paths have no changes' {
        $result = Invoke-GitCommit -Path 'automation/.compiled' -Message 'sync'
        $result | Should -BeNullOrEmpty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0 -ParameterFilter { $Command -like 'git add*' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0 -ParameterFilter { $Command -like 'git commit*' }
    }

    It 'stages and commits the paths and returns the new commit SHA when changes exist' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = " M automation/.compiled/Catzc.Types.abc12345.dll`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -like 'git status --porcelain*' }

        $result = Invoke-GitCommit -Path 'automation/.compiled' -Message 'chore(repo): sync compiled types'
        $result | Should -Be 'abc1234567890abcdef1234567890abcdef12345'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git add -A -- "automation/.compiled"'
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git commit -m "chore(repo): sync compiled types" -- "automation/.compiled"'
        }
    }

    It 'rejects a commit message containing a double quote' {
        { Invoke-GitCommit -Path 'automation/.compiled' -Message 'bad "quote"' } | Should -Throw '*double quote*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }

    It 'rejects a whitespace-only commit message' {
        { Invoke-GitCommit -Path 'automation/.compiled' -Message ' ' } | Should -Throw '*empty or whitespace*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }
}
