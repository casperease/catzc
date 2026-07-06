Describe 'Sync-GeneratedFile' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-GitCurrentBranch { 'feature/sync' } -ModuleName Catzc.Base.ModuleSystem
        Mock Update-Trigger { } -ModuleName Catzc.Base.ModuleSystem
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = " M .triggers/automation.sha256`nD  automation/.compiled/Catzc.Types.old.dll`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -eq 'git status --porcelain' }
        Mock Invoke-GitCommit { 'abc1234567890abcdef1234567890abcdef12345' } -ModuleName Catzc.Base.ModuleSystem
        Mock Write-Message { } -ModuleName Catzc.Base.ModuleSystem
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

    It 'commits on <_> — trunk-based: any named branch is the integration path' -ForEach 'main', 'master' {
        Mock Get-GitCurrentBranch { $_ } -ModuleName Catzc.Base.ModuleSystem
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

    It 'syncs but does not commit while a tracked file outside the generated paths is dirty' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = " M .triggers/automation.sha256`n M automation/Catzc.Base.Files/Invoke-GitCommit.ps1`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -eq 'git status --porcelain' }

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*uncommitted changes*' }
    }

    It 'ignores untracked (??) noise when judging dirtiness' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = " M .triggers/automation.sha256`n?? out/scratch.md`n"; ExitCode = 0 }
        } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -eq 'git status --porcelain' }

        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
    }

    It 'does nothing, quietly, when the generated paths match HEAD' {
        Mock Invoke-Executable {
            [pscustomobject]@{ Output = ''; ExitCode = 0 }
        } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Command -eq 'git status --porcelain' }

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Update-Trigger -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
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
