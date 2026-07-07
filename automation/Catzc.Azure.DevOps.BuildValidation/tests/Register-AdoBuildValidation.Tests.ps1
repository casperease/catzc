# The write side: idempotent create-or-update of one globset's build-validation policy, everything
# defaulted from build-validation.yml, globs.yml, and ado.yml; -DryRun returns the plan (ADR-DRYRUN).
Describe 'Register-AdoBuildValidation' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:globSet = [Catzc.Base.Globs.GlobSet]::new(
            'unit-x', 'd', 'deployable-unit', @('src/**'), @(), @(), @(), -1, 'ci-unit-x')
        $script:buildValidationConfig = [ordered]@{
            branch      = 'main'
            validations = @([ordered]@{ globset = 'unit-x' })
        }
        $script:existingPolicies = @()

        Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith {
            [ordered]@{ organization = 'https://dev.azure.com/org'; project = 'proj' }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-Config -ParameterFilter { $Config -eq 'build-validation' } -MockWith {
            $script:buildValidationConfig
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-GlobSet { $script:globSet } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-AdoPipelineDefinitions {
            @([pscustomobject]@{ Id = 42; Name = 'ci-unit-x' }, [pscustomobject]@{ Id = 43; Name = 'ci-other' })
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Invoke-AdoRestMethod {
            # A mock body sees only BOUND parameters — probe Method and default it like the real command.
            $boundMethod = if (Test-Path variable:Method) {
                $Method
            }
            else {
                'Get'
            }
            if ($boundMethod -in 'Post', 'Put') {
                return [pscustomobject]@{ id = 99 }
            }
            if ($Uri -like '*policy/configurations*') {
                return @($script:existingPolicies)
            }
            return @([pscustomobject]@{ name = 'catzc'; id = 'repo-guid' })
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
    }

    It 'creates a policy path-filtered on the globset native projection, queueing the resolved pipeline' {
        $ret = Register-AdoBuildValidation unit-x -RepositoryName catzc

        $ret.id | Should -Be 99
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $Method -eq 'Post' -and
            $Uri -like '*policy/configurations?api-version*' -and
            $Body.settings.buildDefinitionId -eq 42 -and
            @($Body.settings.filenamePatterns) -contains '/src/**' -and
            $Body.settings.scope[0].refName -eq 'refs/heads/main' -and
            $Body.isBlocking -eq $true
        }
    }

    It 'prefers the entry pipeline and honours entry blocking and display_name' {
        $script:buildValidationConfig = [ordered]@{
            branch      = 'main'
            validations = @([ordered]@{ globset = 'unit-x'; pipeline = 'ci-other'; blocking = $false; display_name = 'custom' })
        }

        Register-AdoBuildValidation unit-x -RepositoryName catzc | Out-Null

        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $Method -eq 'Post' -and
            $Body.settings.buildDefinitionId -eq 43 -and
            $Body.isBlocking -eq $false -and
            $Body.settings.displayName -eq 'custom'
        }
    }

    It 'updates in place when the existing policy differs (a path-filter change never duplicates)' {
        $script:existingPolicies = @([pscustomobject]@{
                id         = 7
                isEnabled  = $true
                isBlocking = $true
                type       = [pscustomobject]@{ id = '0609b952-1397-4640-95ec-e00a01b2c241' }
                settings   = [pscustomobject]@{
                    buildDefinitionId = 42
                    displayName       = 'Build validation - unit-x'
                    filenamePatterns  = @('/old/**')   # a stale path filter
                    scope             = @([pscustomobject]@{ repositoryId = 'repo-guid'; refName = 'refs/heads/main' })
                }
            })

        Register-AdoBuildValidation unit-x -RepositoryName catzc | Out-Null

        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $Method -eq 'Put' -and
            $Uri -like '*policy/configurations/7?api-version*' -and
            @($Body.settings.filenamePatterns) -contains '/src/**'
        }
    }

    It 'is a no-op when the existing policy is already current' {
        $script:existingPolicies = @([pscustomobject]@{
                id         = 7
                isEnabled  = $true
                isBlocking = $true
                type       = [pscustomobject]@{ id = '0609b952-1397-4640-95ec-e00a01b2c241' }
                settings   = [pscustomobject]@{
                    buildDefinitionId = 42
                    displayName       = 'Build validation - unit-x'
                    filenamePatterns  = @('/src/**')
                    scope             = @([pscustomobject]@{ repositoryId = 'repo-guid'; refName = 'refs/heads/main' })
                }
            })

        $ret = Register-AdoBuildValidation unit-x -RepositoryName catzc

        $ret.id | Should -Be 7
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -ParameterFilter {
            $Method -in 'Post', 'Put'
        }
    }

    It 'returns the plan under -DryRun and touches nothing' {
        $plan = Register-AdoBuildValidation unit-x -RepositoryName catzc -DryRun

        $plan.Action | Should -Be 'Create'
        $plan.GlobSet | Should -Be 'unit-x'
        $plan.Pipeline | Should -Be 'ci-unit-x'
        $plan.Branch | Should -Be 'main'
        $plan.PathFilter | Should -Be '/src/**'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -ParameterFilter {
            $Method -in 'Post', 'Put', 'Delete'
        }
    }

    It 'throws when no pipeline is resolvable from any source' {
        $script:globSet = [Catzc.Base.Globs.GlobSet]::new(
            'unit-x', 'd', 'loose-fileset', @('src/**'), @(), @(), @(), -1, $null)   # no pipeline annotation

        { Register-AdoBuildValidation unit-x -RepositoryName catzc } | Should -Throw '*No pipeline for globset*'
    }

    It 'throws when the pipeline is not registered in ADO' {
        Mock Get-AdoPipelineDefinitions { @() } -ModuleName Catzc.Azure.DevOps.BuildValidation

        { Register-AdoBuildValidation unit-x -RepositoryName catzc } | Should -Throw '*not registered*'
    }
}
