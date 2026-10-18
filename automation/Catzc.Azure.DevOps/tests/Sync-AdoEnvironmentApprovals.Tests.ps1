Describe 'Sync-AdoEnvironmentApprovals' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:members = @('a@widget.test')
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'ado' } {
            @{ organization = 'https://dev.azure.com/widgetorg'; project = 'Gadget' }
        }
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'environment-approvals' } {
            [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{
                    approver_group = [ordered]@{ name = 'Widget Approvers'; members = $script:members }
                    timeout_hours  = 8
                    environments   = @('widget-psub', 'widget-prod')
                })
        }
        Mock Get-AdoGraphContext -ModuleName Catzc.Azure.DevOps { [pscustomobject]@{ Project = $Project; Organization = $Organization } }
        Mock Sync-AdoGraphGroup -ModuleName Catzc.Azure.DevOps {
            [pscustomobject]@{ Action = 'Create'; Name = $Name; Descriptor = 'vssgp.g1'; IdentityId = 'group-1' }
        }
        Mock Sync-AdoGraphGroupMembers -ModuleName Catzc.Azure.DevOps { [pscustomobject]@{ Added = @($Member); Removed = @() } }
        Mock Sync-AdoEnvironmentCheck -ModuleName Catzc.Azure.DevOps { 'Create' }
    }

    It 'applies the group, its members and one check per environment, in that order, and reports each' {
        $result = @(Sync-AdoEnvironmentApprovals)
        $result.Kind | Should -Be @('Group', 'Check', 'Check')
        $result.Target | Should -Be @('[Gadget]\Widget Approvers', 'widget-psub', 'widget-prod')
        $result[0].Details | Should -BeLike 'added: a@widget.test; removed: 0'
        Should -Invoke Sync-AdoGraphGroupMembers -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter {
            $Group.Descriptor -eq 'vssgp.g1' -and ($Member -join ',') -eq 'a@widget.test'
        }
        Should -Invoke Sync-AdoEnvironmentCheck -ModuleName Catzc.Azure.DevOps -Times 2 -Exactly -ParameterFilter {
            $ApproverId -eq 'group-1' -and $TimeoutMinutes -eq 480
        }
    }

    It 'passes -DryRun to every step' {
        $result = @(Sync-AdoEnvironmentApprovals -DryRun)
        $result.DryRun | Should -Be @($true, $true, $true)
        Should -Invoke Sync-AdoGraphGroup -ModuleName Catzc.Azure.DevOps -ParameterFilter { $DryRun }
        Should -Invoke Sync-AdoGraphGroupMembers -ModuleName Catzc.Azure.DevOps -ParameterFilter { $DryRun }
        Should -Invoke Sync-AdoEnvironmentCheck -ModuleName Catzc.Azure.DevOps -Times 2 -Exactly -ParameterFilter { $DryRun }
    }

    It 'refuses to apply an empty member list before calling Azure DevOps' {
        $script:members = @()
        { Sync-AdoEnvironmentApprovals } | Should -Throw '*approver_group.members is empty*'
        Should -Invoke Get-AdoGraphContext -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly
    }
}
