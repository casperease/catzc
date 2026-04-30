Describe 'New-AdoPullRequest' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith {
            @{ organization = 'https://dev.azure.com/org'; project = 'proj' }
        } -ModuleName Catzc.Azure.DevOps

        # Mock the REST boundary: repo lookup returns one repo; the PR POST returns a PR object.
        # Check pullrequests first — the PR URL also contains 'git/repositories/<id>/'.
        Mock Invoke-AdoRestMethod {
            if ($Uri -like '*pullrequests*') {
                return [PSCustomObject]@{ pullRequestId = 42 }
            }
            return @([PSCustomObject]@{ name = 'catzc'; id = 'repo-guid' })
        } -ModuleName Catzc.Azure.DevOps
    }

    It 'POSTs a pull request with normalized refs' {
        New-AdoPullRequest -Title 'input: x' -SourceBranch 'feature/x' -RepositoryName 'catzc' | Out-Null
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -like '*pullrequests*' -and
            $Body.sourceRefName -eq 'refs/heads/feature/x' -and
            $Body.targetRefName -eq 'refs/heads/main'
        }
    }

    It 'passes a full refs/ source ref through unchanged' {
        New-AdoPullRequest -Title 'input: x' -SourceBranch 'refs/heads/already' -RepositoryName 'catzc' | Out-Null
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter {
            $Method -eq 'Post' -and $Body.sourceRefName -eq 'refs/heads/already'
        }
    }

    It 'returns the created PR object' {
        $pr = New-AdoPullRequest -Title 'input: x' -SourceBranch 'feature/x' -RepositoryName 'catzc'
        $pr.pullRequestId | Should -Be 42
    }

    It 'throws when the repository is not found' {
        { New-AdoPullRequest -Title 'x' -SourceBranch 'feature/x' -RepositoryName 'nope' } |
            Should -Throw '*not found*'
    }

    It 'requires a title' {
        { New-AdoPullRequest -Title '  ' -SourceBranch 'feature/x' -RepositoryName 'catzc' } | Should -Throw
    }

    It 'requires a source branch' {
        { New-AdoPullRequest -Title 'x' -SourceBranch $null -RepositoryName 'catzc' } | Should -Throw
    }
}
