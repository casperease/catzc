Describe 'Sync-GeneratedFile' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-GitCurrentBranch { 'feature/sync' } -ModuleName Catzc.Base.ModuleSystem
        Mock Test-GitPathChanged { $true } -ModuleName Catzc.Base.ModuleSystem
        Mock Invoke-GitCommit { 'abc1234567890abcdef1234567890abcdef12345' } -ModuleName Catzc.Base.ModuleSystem
        Mock Write-Message { } -ModuleName Catzc.Base.ModuleSystem
        # main-direct workspace (the shipped default) unless a test flips it.
        Mock Test-GitWorkspace { $false } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
    }

    It 'skips in a pipeline before committing anything' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*pipeline*' }
    }

    It 'skips on a detached HEAD with a message and no commit' {
        Mock Get-GitCurrentBranch { 'HEAD' } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
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
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*main-via-pr*' }
    }

    It 'commits from a working branch in the main-via-pr workspace — a branch is always allowed' {
        Mock Test-GitWorkspace { $true } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
    }

    It 'commits the compiled types and reports the branch when they changed' {
        $result = Sync-GeneratedFile
        $result | Should -Be 'abc1234567890abcdef1234567890abcdef12345'
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            ($Path -join ',') -eq 'automation/.compiled' -and $Message -eq 'chore(repo): sync compiled types'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter {
            $Message -eq 'Synced compiled types to feature/sync'
        }
    }

    It 'commits the generated path even while other tracked or staged work is in flight' {
        # The commit is pathspec-limited inside Invoke-GitCommit, so a dirty (or staged) tree never holds
        # the stamp commit back and never leaks into it.
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            ($Path -join ',') -eq 'automation/.compiled'
        }
    }

    It 'does nothing, quietly, when the generated paths match HEAD — no commit is even attempted' {
        Mock Test-GitPathChanged { $false } -ModuleName Catzc.Base.ModuleSystem

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'propagates -DryRun to Invoke-GitCommit and suppresses the synced message' {
        Mock Invoke-GitCommit { 'git add -A -- "automation/.compiled"', 'git commit ...' } -ModuleName Catzc.Base.ModuleSystem

        $planned = Sync-GeneratedFile -DryRun
        $planned.Count | Should -Be 2
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter { $DryRun }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0 -ParameterFilter { $Message -like 'Synced*' }
    }
}
