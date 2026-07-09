# Removal by the globset tie (the native path-filter projection): deletes the matched policy, no-ops when
# absent (ADR-AUTO-IDEM:2), and -DryRun returns the plan (ADR-AUTO-DRYRUN).
Describe 'Unregister-AdoBuildValidation' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:globSet = [Catzc.Base.Globs.GlobSet]::new(
            'unit-x', 'd', 'deployable-unit', @('src/**'), @(), @(), @(), -1, 'ci-unit-x')
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

        Mock Get-Config -ParameterFilter { $Config -eq 'ado' } -MockWith {
            [ordered]@{ organization = 'https://dev.azure.com/org'; project = 'proj' }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-Config -ParameterFilter { $Config -eq 'build-validation' } -MockWith {
            [ordered]@{ branch = 'main'; validations = @([ordered]@{ globset = 'unit-x' }) }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-GlobSet { $script:globSet } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Invoke-AdoRestMethod {
            # A mock body sees only BOUND parameters — probe Method and default it like the real command.
            $boundMethod = if (Test-Path variable:Method) {
                $Method
            }
            else {
                'Get'
            }
            if ($boundMethod -eq 'Delete') {
                return $null
            }
            if ($Uri -like '*policy/configurations*') {
                return @($script:existingPolicies)
            }
            return @([pscustomobject]@{ name = 'catzc'; id = 'repo-guid' })
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
    }

    It 'deletes the policy whose path filter is the globset native projection' {
        Unregister-AdoBuildValidation unit-x -RepositoryName catzc

        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $Method -eq 'Delete' -and $Uri -like '*policy/configurations/7?api-version*'
        }
    }

    It 'is a no-op when no policy is tied to the globset' {
        $script:existingPolicies = @()

        Unregister-AdoBuildValidation unit-x -RepositoryName catzc

        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -ParameterFilter {
            $Method -eq 'Delete'
        }
    }

    It 'returns the plan under -DryRun and touches nothing' {
        $plan = Unregister-AdoBuildValidation unit-x -RepositoryName catzc -DryRun

        $plan.Action | Should -Be 'Remove'
        $plan.PolicyId | Should -Be 7
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -ParameterFilter {
            $Method -eq 'Delete'
        }
    }
}
