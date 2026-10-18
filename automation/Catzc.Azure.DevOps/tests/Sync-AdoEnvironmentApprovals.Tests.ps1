Describe 'Sync-AdoEnvironmentApprovals' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:approvalTypeId = '8c6f20a7-a545-4486-9777-f762fafe0d4d'
        $script:existingChecks = @{}
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'ado' } {
            @{ organization = 'https://dev.azure.com/widgetorg'; project = 'Gadget' }
        }
        Mock Get-Config -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Config -eq 'environment-approvals' } {
            [Catzc.Azure.DevOps.EnvironmentApprovalsConfig]::new([ordered]@{ environments = @('widget-psub', 'widget-prod') })
        }
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/identities?*' } {
            [pscustomobject]@{ id = 'group-1'; providerDisplayName = '[Gadget]\Prod Approvers' }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?*' } {
            $name = [uri]::UnescapeDataString(($Uri -split 'name=')[1].Split('&')[0])
            [pscustomobject]@{ id = "env-$name"; name = $name }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -eq 'Get' -and $Uri -like '*/checks/configurations?resourceType=*' } {
            $id = ($Uri -split 'resourceId=')[1].Split('&')[0]
            $script:existingChecks[$id]
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -in 'Post', 'Patch' } { }
    }

    It 'creates an approval check on every configured environment that has none' {
        $result = @(Sync-AdoEnvironmentApprovals)
        $result.Environment | Should -Be @('widget-psub', 'widget-prod')
        $result.Action | Should -Be @('Create', 'Create')
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 2 -Exactly -ParameterFilter {
            $Method -eq 'Post' -and $Body.settings.approvers[0].id -eq 'group-1' -and $Body.timeout -eq 1440 -and $Body.resource.type -eq 'environment'
        }
    }

    It 'leaves a matching check unchanged and updates one whose approver or timeout drifted' {
        $script:existingChecks['env-widget-psub'] = [pscustomobject]@{
            id = 7; type = @{ id = $script:approvalTypeId }; timeout = 1440; settings = @{ approvers = @(@{ id = 'group-1' }) }
        }
        $script:existingChecks['env-widget-prod'] = [pscustomobject]@{
            id = 8; type = @{ id = $script:approvalTypeId }; timeout = 60; settings = @{ approvers = @(@{ id = 'group-1' }) }
        }
        $result = @(Sync-AdoEnvironmentApprovals)
        $result.Action | Should -Be @('Unchanged', 'Update')
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'Patch' -and $Uri -like '*/checks/configurations/8?*'
        }
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -eq 'Post' }
    }

    It 'reads but writes nothing with -DryRun' {
        $result = @(Sync-AdoEnvironmentApprovals -DryRun)
        $result.Action | Should -Be @('Create', 'Create')
        $result.DryRun | Should -Be @($true, $true)
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -in 'Post', 'Patch' }
    }

    It 'throws, naming the group, when the approver group does not exist' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/_apis/identities?*' } { }
        { Sync-AdoEnvironmentApprovals } | Should -Throw "*Approver group '``[Gadget``]\Prod Approvers' does not exist*"
    }

    It 'throws, naming the environment, when an environment does not exist' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?*' } { }
        { Sync-AdoEnvironmentApprovals } | Should -Throw "*Environment 'widget-psub' does not exist*"
    }

    It 'throws when the organization is not a dev.azure.com URL' {
        { Sync-AdoEnvironmentApprovals -Organization 'https://widgetorg.visualstudio.com' } | Should -Throw '*is not a https://dev.azure.com/<org> URL*'
    }
}
