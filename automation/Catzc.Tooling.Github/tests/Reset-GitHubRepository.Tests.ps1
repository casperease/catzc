Describe 'Reset-GitHubRepository' -Tag 'L1', 'logic' {
    BeforeAll {
        function script:RunReset {
            param([hashtable] $Extra = @{})
            Reset-GitHubRepository -Repo 'me/project' -BackupBundle 'TestDrive:/backup.bundle' -RepositoryPath 'TestDrive:/' @Extra
        }
    }

    BeforeEach {
        Mock -ModuleName Catzc.Tooling.Github Assert-GitHubPurgeReady {}
        Mock -ModuleName Catzc.Tooling.Github Write-Message {}
        Mock -ModuleName Catzc.Tooling.Github Start-Sleep {}
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $true; Blobs = @(); Paths = @(); Messages = @() } }
        # Catch-all: every git/gh command succeeds. Individual tests override as needed.
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' } }
    }

    It 'is a dry run without -ConfirmRepo (nothing destructive runs)' {
        $result = RunReset
        $result.DryRun | Should -BeTrue
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'gh repo delete*' }
    }

    It 'still runs the preflight during a dry run' {
        RunReset | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Assert-GitHubPurgeReady -Times 1
    }

    It 'is a dry run when -ConfirmRepo does not match -Repo' {
        (RunReset @{ ConfirmRepo = 'me/wrong' }).DryRun | Should -BeTrue
    }

    It '-DryRun forces a dry run even when -ConfirmRepo matches' {
        (RunReset @{ ConfirmRepo = 'me/project'; DryRun = $true }).DryRun | Should -BeTrue
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'gh repo delete*' }
    }

    It 'when armed, deletes, recreates, and pushes' {
        $result = RunReset @{ ConfirmRepo = 'me/project' }
        $result.DryRun | Should -BeFalse
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'gh repo delete me/project*' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'gh repo create me/project *' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -eq 'git push -u origin main' }
    }

    It 'runs the post-verify scan when a token is given' {
        RunReset @{ ConfirmRepo = 'me/project'; Token = 'old-name' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Test-GitHistoryClean -Times 1
    }

    It 'aborts with a do-not-publish warning when post-verify finds the token' {
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $false; Blobs = @('rev:file:1'); Paths = @(); Messages = @() } }
        { RunReset @{ ConfirmRepo = 'me/project'; Token = 'old-name' } } | Should -Throw '*DO NOT make it public*'
    }

    It 'when renaming, creates under the new name after checking it is free' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'not found' } } -ParameterFilter { $Command -like 'gh repo view me/new*' }
        RunReset @{ ConfirmRepo = 'me/project'; NewName = 'me/new' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'gh repo delete me/project*' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'gh repo create me/new *' }
    }

    It 'when renaming, aborts if the target name is already taken' {
        # Catch-all returns exit 0 for `gh repo view me/new`, i.e. the name exists.
        { RunReset @{ ConfirmRepo = 'me/project'; NewName = 'me/new' } } | Should -Throw '*already exists*'
    }

    It 'reports intact state when the delete fails' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'permission denied' } } -ParameterFilter { $Command -like 'gh repo delete*' }
        { RunReset @{ ConfirmRepo = 'me/project' } } | Should -Throw '*Delete failed*'
    }

    It 'propagates a preflight failure without touching the remote' {
        Mock -ModuleName Catzc.Tooling.Github Assert-GitHubPurgeReady { throw 'preflight boom' }
        { RunReset @{ ConfirmRepo = 'me/project' } } | Should -Throw '*preflight boom*'
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'gh repo delete*' }
    }
}
