Describe 'Assert-GitHubPurgeReady' -Tag 'L1', 'logic' {
    BeforeAll {
        # Calls the function under test with the standard-good arguments, plus any override.
        function script:Invoke-PurgeReadyAssert {
            param([hashtable] $Extra = @{})
            Assert-GitHubPurgeReady -Repo 'me/project' -BackupBundle 'TestDrive:/backup.bundle' -RepositoryPath 'TestDrive:/' @Extra
        }
    }

    BeforeEach {
        Mock -ModuleName Catzc.Tooling.Github Assert-Command {}
        Mock -ModuleName Catzc.Tooling.Github Write-Message {}
        Mock -ModuleName Catzc.Tooling.Github Test-Path { $true }

        # Catch-all first: a command no later mock answers is a broken test, never a real launch.
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { throw "unexpected command: $Command" }

        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = ''; Errors = '' } } -ParameterFilter { $Command -eq 'gh auth status' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"login":"me"}'; Errors = '' } } -ParameterFilter { $Command -eq 'gh api user' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = "status: 200`n scopes: repo, delete_repo, workflow"; Errors = '' } } -ParameterFilter { $Command -eq 'gh api -i user' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"owner":{"login":"me"},"isFork":false,"forkCount":0,"visibility":"private"}'; Errors = '' } } -ParameterFilter { $Command -like 'gh repo view*' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'https://github.com/me/project.git'; Errors = '' } } -ParameterFilter { $Command -eq 'git config --get remote.origin.url' }
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'The bundle records a complete history.'; Errors = '' } } -ParameterFilter { $Command -like 'git bundle verify*' }
    }

    It 'passes when every precondition is met' {
        { Invoke-PurgeReadyAssert } | Should -Not -Throw
    }

    It 'throws when gh is not authenticated' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = '' } } -ParameterFilter { $Command -eq 'gh auth status' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*not authenticated*'
    }

    It 'throws when the token lacks the delete_repo scope' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = "status: 200`n scopes: repo, workflow"; Errors = '' } } -ParameterFilter { $Command -eq 'gh api -i user' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*delete_repo scope*'
    }

    It 'throws when the caller does not own the repo' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"owner":{"login":"someone-else"},"isFork":false,"forkCount":0,"visibility":"private"}'; Errors = '' } } -ParameterFilter { $Command -like 'gh repo view*' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*not the owner*'
    }

    It 'throws when the repo has forks' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"owner":{"login":"me"},"isFork":false,"forkCount":3,"visibility":"private"}'; Errors = '' } } -ParameterFilter { $Command -like 'gh repo view*' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*fork*'
    }

    It 'passes with forks when -AllowForks is set' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = '{"owner":{"login":"me"},"isFork":false,"forkCount":3,"visibility":"private"}'; Errors = '' } } -ParameterFilter { $Command -like 'gh repo view*' }
        { Invoke-PurgeReadyAssert @{ AllowForks = $true } } | Should -Not -Throw
    }

    It 'throws when local origin does not match the repo' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 0; Output = 'https://github.com/me/other.git'; Errors = '' } } -ParameterFilter { $Command -eq 'git config --get remote.origin.url' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*expected*'
    }

    It 'throws when the backup bundle fails verification' {
        Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { [pscustomobject]@{ ExitCode = 1; Output = ''; Errors = 'error: not a valid bundle' } } -ParameterFilter { $Command -like 'git bundle verify*' }
        { Invoke-PurgeReadyAssert } | Should -Throw '*failed verification*'
    }

    It 'throws when the backup bundle is missing' {
        Mock -ModuleName Catzc.Tooling.Github Test-Path { $false }
        { Invoke-PurgeReadyAssert } | Should -Throw '*not found*'
    }
}
