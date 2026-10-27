Describe 'Register-AdoBranchPolicies' -Tag 'L0', 'logic', 'EDR-AZ-CAF-DEVOPS-R25', 'EDR-AZ-CAF-DEVOPS-R26' {
    BeforeEach {
        $script:policies = [Catzc.Azure.DevOps.BuildValidation.BranchPolicies]::new([ordered]@{})
        Mock Get-Config -ParameterFilter { $Config -eq 'build-validation' } -MockWith {
            [pscustomobject]@{ branch = 'main'; policies = $script:policies }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Resolve-AdoBuildValidationContext {
            @{ ApiBase = 'https://ado.example/widget/_apis'; RepositoryId = 'r1'; Project = 'widget'; Organization = 'https://ado.example'; RepositoryName = 'gadget' }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Invoke-AdoRestMethod -ParameterFilter { -not $Method } -MockWith { @() } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Invoke-AdoRestMethod -ParameterFilter { $Method } -MockWith { @{ id = 7 } } -ModuleName Catzc.Azure.DevOps.BuildValidation
        Mock Write-Message { } -ModuleName Catzc.Azure.DevOps.BuildValidation
    }

    It 'plans the default reviewer, merge and comment policies on the branch, without touching the server, under -DryRun' {
        $plan = @(Register-AdoBranchPolicies -Project widget -Organization https://ado.example -RepositoryName gadget -DryRun)
        $plan.Policy | Should -Be @('Minimum number of reviewers', 'Require a merge strategy', 'Comment requirements')
        $plan.Action | Should -Be @('Create', 'Create', 'Create')
        $plan[0].Settings.minimumApproverCount | Should -Be 1
        $plan[0].Settings.creatorVoteCounts | Should -BeFalse
        $plan[0].Settings.resetOnSourcePush | Should -BeTrue
        $plan[1].Settings.allowSquash | Should -BeTrue
        $plan[1].Settings.allowNoFastForward | Should -BeFalse
        $plan[1].Settings.allowRebase | Should -BeFalse
        $plan[1].Settings.allowRebaseMerge | Should -BeFalse
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 0 -Exactly -ParameterFilter { $Method }
    }

    It 'creates each missing policy, blocking and scoped to the branch' {
        $null = Register-AdoBranchPolicies -Project widget -Organization https://ado.example -RepositoryName gadget
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps.BuildValidation -Times 3 -Exactly -ParameterFilter {
            $Method -eq 'Post' -and $Body.isBlocking -and $Body.settings.scope[0].refName -eq 'refs/heads/main' -and
            $Body.settings.scope[0].repositoryId -eq 'r1'
        }
    }

    It 'leaves a current policy alone and updates one that drifted' {
        Mock Invoke-AdoRestMethod -ParameterFilter { -not $Method } -MockWith {
            $scope = @([pscustomobject]@{ refName = 'refs/heads/main'; repositoryId = 'r1' })
            [pscustomobject]@{ id = 1; isEnabled = $true; isBlocking = $true; type = [pscustomobject]@{ id = 'fa4e907d-c16b-4a4c-9dfa-4906e5d171dd' }
                settings = [pscustomobject]@{ minimumApproverCount = 1; creatorVoteCounts = $false; resetOnSourcePush = $true; allowDownvotes = $false; scope = $scope }
            }
            [pscustomobject]@{ id = 2; isEnabled = $true; isBlocking = $true; type = [pscustomobject]@{ id = 'fa4e907d-c16b-4a4c-9dfa-4916e5d171ab' }
                settings = [pscustomobject]@{ allowSquash = $true; allowNoFastForward = $true; allowRebase = $false; allowRebaseMerge = $false; scope = $scope }
            }
        } -ModuleName Catzc.Azure.DevOps.BuildValidation
        $plan = @(Register-AdoBranchPolicies -Project widget -Organization https://ado.example -RepositoryName gadget -DryRun)
        $plan.Action | Should -Be @('Unchanged', 'Update', 'Create')
    }

    It 'adds a required-reviewer policy only when the config names reviewer ids' {
        $script:policies = [Catzc.Azure.DevOps.BuildValidation.BranchPolicies]::new([ordered]@{
                automatic_reviewer_ids = @('0f0e0000-7e0a-0700-1d00-000000000000'); require_comment_resolution = $false; minimum_reviewers = 2
            })
        $plan = @(Register-AdoBranchPolicies -Project widget -Organization https://ado.example -RepositoryName gadget -DryRun)
        $plan.Policy | Should -Be @('Minimum number of reviewers', 'Require a merge strategy', 'Required reviewers')
        $plan[0].Settings.minimumApproverCount | Should -Be 2
        $plan[2].Settings.requiredReviewerIds | Should -Be @('0f0e0000-7e0a-0700-1d00-000000000000')
    }
}
