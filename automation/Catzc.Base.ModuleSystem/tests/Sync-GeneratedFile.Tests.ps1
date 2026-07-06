Describe 'Sync-GeneratedFile' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-GitCurrentBranch { 'feature/sync' } -ModuleName Catzc.Base.ModuleSystem
        Mock Update-Trigger { } -ModuleName Catzc.Base.ModuleSystem
        Mock Invoke-GitCommit { 'abc1234567890abcdef1234567890abcdef12345' } -ModuleName Catzc.Base.ModuleSystem
        Mock Write-Message { } -ModuleName Catzc.Base.ModuleSystem
        # main-direct workspace (the shipped default) unless a test flips it.
        Mock Test-GitWorkspace { $false } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
    }

    It 'skips in a pipeline before syncing anything' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*pipeline*' }
    }

    It 'skips on a detached HEAD with a message and no sync' {
        Mock Get-GitCurrentBranch { 'HEAD' } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'commits on <_> in the main-direct workspace — the trunk IS the integration path' -ForEach 'main', 'master' {
        Mock Get-GitCurrentBranch { $_ } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
    }

    It 'skips on <_> in the main-via-pr workspace — standing on main is the one forbidden place' -ForEach 'main', 'master' {
        Mock Get-GitCurrentBranch { $_ } -ModuleName Catzc.Base.ModuleSystem
        Mock Test-GitWorkspace { $true } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*main-via-pr*' }
    }

    It 'commits from a working branch in the main-via-pr workspace — a branch is always allowed' {
        Mock Test-GitWorkspace { $true } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
    }

    It 'syncs, commits both generated paths, and reports the branch on a clean tree' {
        $result = Sync-GeneratedFile
        $result | Should -Be 'abc1234567890abcdef1234567890abcdef12345'
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            ($Path -join ',') -eq '.triggers,automation/.compiled' -and $Message -eq 'chore(repo): sync trigger files and compiled types'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter {
            $Message -eq 'Sha files were synced to feature/sync'
        }
    }

    It 'commits the generated paths even while other tracked or staged work is in flight' {
        # The commit is pathspec-limited inside Invoke-GitCommit, so a dirty (or staged) tree never holds
        # the stamp commit back and never leaks into it.
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            ($Path -join ',') -eq '.triggers,automation/.compiled'
        }
    }

    It 'does nothing, quietly, when the generated paths match HEAD' {
        # Invoke-GitCommit is the idempotent no-op (returns nothing) when nothing changed under its paths.
        Mock Invoke-GitCommit { } -ModuleName Catzc.Base.ModuleSystem

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'propagates -DryRun to Invoke-GitCommit and suppresses the synced message' {
        Mock Invoke-GitCommit { 'git add -A -- ".triggers" "automation/.compiled"', 'git commit ...' } -ModuleName Catzc.Base.ModuleSystem

        $planned = Sync-GeneratedFile -DryRun
        $planned.Count | Should -Be 2
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter { $DryRun }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0 -ParameterFilter { $Message -like 'Sha files*' }
    }
}
