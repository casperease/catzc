Describe 'Publish-CleanHistory' -Tag 'L1', 'logic' {
    BeforeAll {
        function script:RunPublish {
            param([hashtable] $Extra = @{})
            Publish-CleanHistory -NewRepo 'me/fresh' -RepositoryPath 'TestDrive:/' @Extra
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

    It 'aborts with a do-not-publish warning when the post-verify scan finds the token' {
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $true; Blobs = @(); Paths = @(); Messages = @() } } -ParameterFilter { $Ref -eq 'main' }
        Mock -ModuleName Catzc.Tooling.Github Test-GitHistoryClean { [pscustomobject]@{ Clean = $false; Blobs = @('rev:file:1'); Paths = @(); Messages = @() } } -ParameterFilter { $Ref -eq '--all' }
        { RunPublish @{ ConfirmRepo = 'me/fresh'; Token = 'old-name' } } | Should -Throw '*DO NOT make it public*'
    }
}
