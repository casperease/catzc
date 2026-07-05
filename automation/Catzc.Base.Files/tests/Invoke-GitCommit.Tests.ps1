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
        $planned = Invoke-GitCommit -Path '.triggers', 'automation/.compiled' -Message 'sync' -DryRun
        $planned.Count | Should -Be 2
        $planned[0] | Should -Be 'git add -A -- ".triggers" "automation/.compiled"'
        $planned[1] | Should -Be 'git commit -m "sync" -- ".triggers" "automation/.compiled"'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }

    It 'returns nothing and does not commit when the paths have no changes' {
        $result = Invoke-GitCommit -Path '.triggers' -Message 'sync'
        $result | Should -BeNullOrEmpty
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0 -ParameterFilter { $Command -like 'git add*' }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0 -ParameterFilter { $Command -like 'git commit*' }
    }

    It 'stages and commits the paths and returns the new commit SHA when changes exist' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = " M .triggers/automation.sha256`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.Files -ParameterFilter { $Command -like 'git status --porcelain*' }

        $result = Invoke-GitCommit -Path '.triggers' -Message 'chore(triggers): sync trigger files'
        $result | Should -Be 'abc1234567890abcdef1234567890abcdef12345'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git add -A -- ".triggers"'
        }
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git commit -m "chore(triggers): sync trigger files" -- ".triggers"'
        }
    }

    It 'rejects a commit message containing a double quote' {
        { Invoke-GitCommit -Path '.triggers' -Message 'bad "quote"' } | Should -Throw '*double quote*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }

    It 'rejects a whitespace-only commit message' {
        { Invoke-GitCommit -Path '.triggers' -Message ' ' } | Should -Throw '*empty or whitespace*'
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }
}
