Describe 'Sync-AdoEnvironmentCheck' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:approvalTypeId = '8c6f20a7-a545-4486-9777-f762fafe0d4d'
        $script:context = [pscustomobject]@{ Organization = 'https://dev.azure.com/widgetorg'; Project = 'Gadget'; ApiBase = 'https://dev.azure.com/widgetorg/Gadget/_apis' }
        $script:sync = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Sync-AdoEnvironmentCheck @A }
        }
    }

    BeforeEach {
        $script:existing = $null
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?*' } {
            $name = [uri]::UnescapeDataString(($Uri -split 'name=')[1].Split('&')[0])
            [pscustomobject]@{ id = 42; name = $name }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/checks/configurations?resourceType=*' } { $script:existing }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -in 'Post', 'Patch' } { }
    }

    It 'creates the check when the environment has none' {
        & $script:sync @{ Context = $script:context; Environment = 'widget-psub'; ApproverId = 'group-1'; TimeoutMinutes = 1440 } | Should -Be 'Create'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'Post' -and $Body.settings.approvers[0].id -eq 'group-1' -and $Body.timeout -eq 1440 -and $Body.resource.id -eq '42'
        }
    }

    It 'leaves a matching check unchanged' {
        $script:existing = [pscustomobject]@{ id = 7; type = @{ id = $script:approvalTypeId }; timeout = 1440; settings = @{ approvers = @(@{ id = 'group-1' }) } }
        & $script:sync @{ Context = $script:context; Environment = 'widget-psub'; ApproverId = 'group-1'; TimeoutMinutes = 1440 } | Should -Be 'Unchanged'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -in 'Post', 'Patch' }
    }

    It 'updates a check whose approver or timeout drifted' -ForEach @(
        @{ Approver = 'group-2'; Timeout = 1440 }
        @{ Approver = 'group-1'; Timeout = 60 }
    ) {
        $script:existing = [pscustomobject]@{ id = 7; type = @{ id = $script:approvalTypeId }; timeout = $Timeout; settings = @{ approvers = @(@{ id = $Approver }) } }
        & $script:sync @{ Context = $script:context; Environment = 'widget-psub'; ApproverId = 'group-1'; TimeoutMinutes = 1440 } | Should -Be 'Update'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter { $Method -eq 'Patch' -and $Uri -like '*/configurations/7?*' }
    }

    It 'reads but writes nothing with -DryRun, even without an approver id yet' {
        & $script:sync @{ Context = $script:context; Environment = 'widget-psub'; ApproverId = ''; TimeoutMinutes = 1440; DryRun = $true } | Should -Be 'Create'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -in 'Post', 'Patch' }
    }

    It 'throws, naming the environment, when it does not exist' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/distributedtask/environments?*' } { }
        { & $script:sync @{ Context = $script:context; Environment = 'widget-psub'; ApproverId = 'group-1'; TimeoutMinutes = 1440 } } |
            Should -Throw "*Environment 'widget-psub' does not exist*"
    }
}
