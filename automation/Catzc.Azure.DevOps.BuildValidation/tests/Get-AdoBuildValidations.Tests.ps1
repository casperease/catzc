# The read side: policy configurations filtered to build-validation policies of THIS repository,
# optionally one branch, flattened to one row per policy.
Describe 'Get-AdoBuildValidations' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith {
            [ordered]@{ organization = 'https://dev.azure.com/org'; project = 'proj' }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation

        $script:buildPolicy = [pscustomobject]@{
            id         = 7
            isEnabled  = $true
            isBlocking = $true
            type       = [pscustomobject]@{ id = '0609b952-1397-4640-95ec-e00a01b2c241' }
            settings   = [pscustomobject]@{
                buildDefinitionId = 42
                displayName       = 'Build validation - unit-x'
                filenamePatterns  = @('/.sha-markers/unit-x.yml')
                scope             = @([pscustomobject]@{ repositoryId = 'repo-guid'; refName = 'refs/heads/main'; matchKind = 'Exact' })
            }
        }
        $script:otherBranchPolicy = [pscustomobject]@{
            id         = 8
            isEnabled  = $true
            isBlocking = $false
            type       = [pscustomobject]@{ id = '0609b952-1397-4640-95ec-e00a01b2c241' }
            settings   = [pscustomobject]@{
                buildDefinitionId = 43
                displayName       = 'Build validation - release'
                filenamePatterns  = @('/.sha-markers/unit-y.yml')
                scope             = @([pscustomobject]@{ repositoryId = 'repo-guid'; refName = 'refs/heads/release'; matchKind = 'Exact' })
            }
        }
        $script:foreignPolicy = [pscustomobject]@{
            id         = 9
            isEnabled  = $true
            isBlocking = $true
            type       = [pscustomobject]@{ id = 'fa0e0000-0e00-1d00-0000-000000000000' }   # not a Build policy
            settings   = [pscustomobject]@{ scope = @([pscustomobject]@{ repositoryId = 'repo-guid'; refName = 'refs/heads/main' }) }
        }

        Mock Invoke-AdoRestMethod {
            if ($Uri -like '*policy/configurations*') {
                return @($script:buildPolicy, $script:otherBranchPolicy, $script:foreignPolicy)
            }
            return @([pscustomobject]@{ name = 'catzc'; id = 'repo-guid' })
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
    }

    It 'returns one row per build-validation policy of the repository' {
        $result = @(Get-AdoBuildValidations -RepositoryName catzc)
        $result.Count | Should -Be 2
        $result.Id | Should -Be @(7, 8)
    }

    It 'flattens the policy into id, pipeline, branch, path filters, and flags' {
        $row = @(Get-AdoBuildValidations -Branch main -RepositoryName catzc)[0]
        $row.Id | Should -Be 7
        $row.DisplayName | Should -Be 'Build validation - unit-x'
        $row.PipelineDefinitionId | Should -Be 42
        $row.Branch | Should -Be 'main'
        $row.PathFilters | Should -Be @('/.sha-markers/unit-x.yml')
        $row.Blocking | Should -BeTrue
        $row.Enabled | Should -BeTrue
        $row.Raw.id | Should -Be 7
    }

    It 'filters to the requested branch' {
        $result = @(Get-AdoBuildValidations -Branch release -RepositoryName catzc)
        $result.Count | Should -Be 1
        $result.Id | Should -Be 8
    }

    It 'never returns a non-build policy' {
        @(Get-AdoBuildValidations -RepositoryName catzc).Id | Should -Not -Contain 9
    }

    It 'throws when the repository is not found' {
        { Get-AdoBuildValidations -RepositoryName nope } | Should -Throw '*not found*'
    }
}
