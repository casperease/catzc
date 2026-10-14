Describe 'Publish-CleanHistory' -Tag 'L1', 'logic' {
    BeforeAll {
        function script:RunPublish {
            param([hashtable] $Extra = @{})
            Publish-CleanHistory -NewRepo 'me/fresh' -RepositoryPath 'TestDrive:/' @Extra
        }
        # `git ls-remote` output: one tab-separated '<commit> <ref>' line per advertised ref.
        function script:New-RefListing {
            param([string[]] $Ref)
            ($Ref | ForEach-Object { $_ -replace ' ', [char]9 }) -join [Environment]::NewLine
        }
    }

    BeforeEach {
        Mock -ModuleName Catzc.Tooling.Github Assert-Command {}
        Mock -ModuleName Catzc.Tooling.Github Write-Message {}
        Mock -ModuleName Catzc.Tooling.Github Start-Sleep {}
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $true; Blobs = @(); Paths = @(); Messages = @() } }
        # Everything succeeds by default...
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' } }
        # ...except the existence probe: the target name is free (exit 1 = not found).
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'not found' } } -ParameterFilter { $Command -like 'gh repo view me/fresh*' }
        # The pushed remote advertises only the local branch's commit.
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'aaa111'; Errors = '' } } -ParameterFilter { $Command -like 'git rev-parse*' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = (New-RefListing 'aaa111 HEAD', 'aaa111 refs/heads/main'); Errors = '' } } -ParameterFilter { $Command -like 'git ls-remote*' }
    }

    It 'is a dry run without -ConfirmRepo (nothing created)' {
        (RunPublish).DryRun | Should -BeTrue
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'gh repo create*' }
    }

    It 'when armed, creates the repo and pushes' {
        $result = RunPublish @{ ConfirmRepo = 'me/fresh' }
        $result.DryRun | Should -BeFalse
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'gh repo create me/fresh *' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -eq 'git push -u origin main' }
    }

    It 'aborts when the target repo already exists' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"name":"fresh"}'; Errors = '' } } -ParameterFilter { $Command -like 'gh repo view me/fresh*' }
        { RunPublish @{ ConfirmRepo = 'me/fresh' } } | Should -Throw '*already exists*'
    }

    It 'refuses to publish a local history that still contains the token' {
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $false; Blobs = @('rev:file:1'); Paths = @(); Messages = @() } } -ParameterFilter { $Ref -eq 'main' }
        { RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } } | Should -Throw '*clean it before publishing*'
    }

    It 'bounds the push and the remote read with its own time limit' {
        $limit = Get-TimeoutSeconds -Command 'Publish-CleanHistory'
        RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'git push*' -and $TimeoutSeconds -eq $limit }
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 1 -ParameterFilter { $Command -like 'git ls-remote*' -and $TimeoutSeconds -eq $limit }
    }

    It 'verifies the remote by its refs, never by a mirror clone' {
        RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } | Out-Null
        Should -Invoke -ModuleName Catzc.Tooling.Github Invoke-Executable -Times 0 -ParameterFilter { $Command -like 'git clone*' }
        Should -Invoke -ModuleName Catzc.Tooling.Github Test-GitHistoryClean -Times 1 -Exactly -ParameterFilter { $Ref -eq 'main' }
    }

    It 'aborts with a do-not-publish warning when the remote holds a commit the local scan did not cover' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = (New-RefListing 'aaa111 refs/heads/main', 'bbb222 refs/heads/gadget'); Errors = '' } } -ParameterFilter { $Command -like 'git ls-remote*' }
        { RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } } | Should -Throw '*refs/heads/gadget (bbb222)*DO NOT make it public*'
    }

    It 'aborts when the remote does not advertise the pushed branch' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' } } -ParameterFilter { $Command -like 'git ls-remote*' }
        { RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } } | Should -Throw '*does not advertise refs/heads/main*'
    }
}
