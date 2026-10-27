Describe 'Sync-AdoBuildValidations' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config -ParameterFilter { $Config -eq 'build-validation' } -MockWith {
            [ordered]@{
                branch      = 'main'
                validations = @(
                    [ordered]@{ globset = 'unit-x' }
                    [ordered]@{ globset = 'unit-y'; pipeline = 'ci-unit-y' }
                )
            }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Register-AdoBuildValidation {
            [pscustomobject]@{ GlobSet = $GlobSet; Action = 'Unchanged' }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Register-AdoBranchPolicies { [pscustomobject]@{ Policy = 'widget'; Action = 'Unchanged' } } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Get-GitWorkspace { 'main-direct' } -ModuleName Catzc.Azure.DevOps.BuildValidation
    }

    It 'applies the branch policies only when the git_workspace variant is main-via-pr, with the same overrides' {
        Sync-AdoBuildValidations -DryRun -Branch release | Out-Null
        Should -Invoke Register-AdoBranchPolicies -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -Exactly

        Mock Get-GitWorkspace { 'main-via-pr' } -ModuleName Catzc.Azure.DevOps.BuildValidation
        $result = @(Sync-AdoBuildValidations -DryRun -Branch release)
        $result.Count | Should -Be 3
        Should -Invoke Register-AdoBranchPolicies -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 1 -Exactly -ParameterFilter {
            $DryRun -and $Branch -eq 'release'
        }
    }

    It 'registers every configured entry and emits each result' {
        $result = @(Sync-AdoBuildValidations)

        $result.Count | Should -Be 2
        Should -Invoke Register-AdoBuildValidation -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $GlobSet -eq 'unit-x'
        }
        Should -Invoke Register-AdoBuildValidation -ModuleName Catzc.Azure.DevOps.BuildValidation -ParameterFilter {
            $GlobSet -eq 'unit-y'
        }
    }

    It 'passes -DryRun and the overrides through' {
        Sync-AdoBuildValidations -DryRun -Branch release -RepositoryName catzc | Out-Null

        Should -Invoke Register-AdoBuildValidation -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 2 -ParameterFilter {
            $DryRun -and $Branch -eq 'release' -and $RepositoryName -eq 'catzc'
        }
    }

    It 'never resolves ADO context itself — registration owns the server round-trips' {
        Mock Resolve-AdoBuildValidationContext { throw 'not expected' } -ModuleName Catzc.Azure.DevOps.BuildValidation
        { Sync-AdoBuildValidations } | Should -Not -Throw
    }
}
