<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.ModuleSystem/tests/Sync-GeneratedFile.Tests.ps1
    folder: tests
    name: sync-generated-file-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-modulesystem/tests/Sync-GeneratedFile.Tests.ps1.md
    cites:
      - ADR-AUTO-CACHE#8
      - ADR-AUTO-TYPES#13
---
#>

Describe 'Sync-GeneratedFile' -Tag 'L0', 'logic' {
    BeforeEach {
        # Source mode unless a test flips it, so the cases run the same in the source and build runs.
        Mock Get-CatzcRunMode { 'source' } -ModuleName Catzc.Base.ModuleSystem
        # A person's devbox session unless a test flips it — the one actor that commits.
        Mock Get-SessionActor { 'Person' } -ModuleName Catzc.Base.ModuleSystem
        Mock Test-RepositorySnapshot { $false } -ModuleName Catzc.Base.ModuleSystem
        Mock Get-GitCurrentBranch { 'feature/sync' } -ModuleName Catzc.Base.ModuleSystem
        Mock Test-GitPathChanged { $true } -ModuleName Catzc.Base.ModuleSystem
        # The type sources match HEAD unless a test dirties them.
        Mock Test-GitPathChanged { $false } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Path -contains 'automation/*/types/*.cs' }
        Mock Invoke-GitCommit { 'abc1234567890abcdef1234567890abcdef12345' } -ModuleName Catzc.Base.ModuleSystem
        Mock Write-Message { } -ModuleName Catzc.Base.ModuleSystem
        # A tidy .compiled (only the current build) unless a test plants a superseded one.
        Mock Clear-ModuleTypeCache { } -ModuleName Catzc.Base.ModuleSystem
        # main-direct workspace (the shipped default) unless a test flips it.
        Mock Test-GitWorkspace { $false } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $MainViaPr }
    }

    It 'skips in build mode before probing or committing anything' {
        Mock Get-CatzcRunMode { 'build' } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Test-GitPathChanged -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*built Catzc package*' }
    }

    It 'skips in a pipeline before committing anything' {
        Mock Get-SessionActor { 'Pipeline' } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter { $Message -like '*pipeline*' }
    }

    It 'never commits in an agent session, and announces what the person should commit' -Tag 'ADR-AUTO-TYPES#13' {
        Mock Get-SessionActor { 'Agent' } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -ParameterFilter {
            $Message -like '*agent session*automation/.compiled*commit them*'
        }
    }

    It 'never commits inside a test-run snapshot, whoever runs it' {
        Mock Test-RepositorySnapshot { $true } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Test-GitPathChanged -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'stays quiet in an agent session when no generated file changed' {
        Mock Get-SessionActor { 'Agent' } -ModuleName Catzc.Base.ModuleSystem
        Mock Test-GitPathChanged { $false } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0
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

    It 'probes .compiled for superseded builds read-only and silently before committing it' {
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter { $DryRun -and $Silent }
    }

    It 'holds back .compiled with a red line naming the surplus while a superseded build remains' {
        Mock Clear-ModuleTypeCache {
            (Join-Path $TestDrive 'Catzc.Types.widget02.dll'), (Join-Path $TestDrive 'Catzc.Types.widget01.dll')
        } -ModuleName Catzc.Base.ModuleSystem

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            $Message -like '*Catzc.Types.widget01.dll, Catzc.Types.widget02.dll*' -and $ForegroundColor -eq 'Red'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0 -ParameterFilter { $Message -like 'Synced*' }
    }

    It 'holds back .compiled with a yellow line while a type source differs from HEAD' -Tag 'ADR-AUTO-CACHE#8' {
        Mock Test-GitPathChanged { $true } -ModuleName Catzc.Base.ModuleSystem -ParameterFilter { $Path -contains 'automation/*/types/*.cs' }

        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Invoke-GitCommit -ModuleName Catzc.Base.ModuleSystem -Times 0
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            $Message -like 'Skipped automation/.compiled: type sources*' -and $ForegroundColor -eq 'Yellow'
        }
        Should -Invoke Write-Message -ModuleName Catzc.Base.ModuleSystem -Times 0 -ParameterFilter { $Message -like 'Synced*' }
    }

    It 'checks the type sources against HEAD before committing .compiled' {
        Sync-GeneratedFile | Should -Not -BeNullOrEmpty
        Should -Invoke Test-GitPathChanged -ModuleName Catzc.Base.ModuleSystem -Times 1 -Exactly -ParameterFilter {
            $Path -contains 'automation/*/types/*.cs'
        }
    }

    It 'does not probe .compiled when it matches HEAD' {
        Mock Test-GitPathChanged { $false } -ModuleName Catzc.Base.ModuleSystem
        Sync-GeneratedFile | Should -BeNullOrEmpty
        Should -Invoke Clear-ModuleTypeCache -ModuleName Catzc.Base.ModuleSystem -Times 0
    }

    It 'commits the generated path even while other tracked or staged work is in flight' {
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
