<#
---
catzc:
  immutable:
    with_body_sha: def2f4c13125
  edges:
    code: pwsh/Catzc.Tooling.Github/Reset-GitHubRepository.ps1
---
#>

Describe 'Reset-GitHubRepository' -Tag 'L1', 'logic' {
    BeforeAll {
        # A local checkout written by hand: main at a made-up commit, read in-process by the remote check.
        $script:local = '{0:x40}' -f 1
        $script:foreign = '{0:x40}' -f 2
        $script:repo = Join-Path $TestDrive 'widget'
        [System.IO.Directory]::CreateDirectory((Join-Path $script:repo '.git/refs/heads')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $script:repo '.git/HEAD'), "ref: refs/heads/main`n")
        [System.IO.File]::WriteAllText((Join-Path $script:repo '.git/refs/heads/main'), "$script:local`n")

        function script:RunReset {
            param([hashtable] $Extra = @{})
            Reset-GitHubRepository -Repo 'me/project' -BackupBundle 'TestDrive:/backup.bundle' -RepositoryPath $script:repo @Extra
        }
        # `git ls-remote` output: one tab-separated '<commit> <ref>' line per advertised ref.
        function script:New-RefListing {
            param([string[]] $Ref)
            ($Ref | ForEach-Object { $_ -replace ' ', [char]9 }) -join [Environment]::NewLine
        }
    }

    BeforeEach {
        Mock -ModuleName Catzc.Tooling.Github Assert-GitHubPurgeReady {}
        Mock -ModuleName Catzc.Tooling.Github Write-Message {}
        Mock -ModuleName Catzc.Tooling.Github Start-Sleep {}
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $true; Blobs = @(); Paths = @(); Messages = @() } }
        # Catch-all: every git/gh command succeeds. Individual tests override as needed.
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' } }
        # The pushed remote advertises only the local branch's commit.
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = (New-RefListing "$script:local HEAD", "$script:local refs/heads/main"); Errors = '' } } -ParameterFilter { $Command -like 'git ls-remote*' }
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

    It 'runs the post-verify scan on the pushed branch, never on a mirror clone, when a token is given' {
        RunReset @{ ConfirmRepo = 'me/project'; Token = 'old-name' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Test-GitHistoryClean -Times 1 -Exactly -ParameterFilter { $Ref -eq 'main' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'git clone*' }
    }

    It 'bounds the push and the remote read with its own time limit' {
        $limit = Get-TimeoutSeconds -Command 'Reset-GitHubRepository'
        RunReset @{ ConfirmRepo = 'me/project'; Token = 'old-name' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'git push*' -and $TimeoutSeconds -eq $limit }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'git ls-remote*' -and $TimeoutSeconds -eq $limit }
    }

    It 'aborts with a do-not-publish warning when the remote holds a commit the local scan did not cover' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = (New-RefListing "$script:local refs/heads/main", "$script:foreign refs/heads/gadget"); Errors = '' } } -ParameterFilter { $Command -like 'git ls-remote*' }
        { RunReset @{ ConfirmRepo = 'me/project'; Token = 'old-name' } } | Should -Throw "*refs/heads/gadget ($script:foreign)*DO NOT make it public*"
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
