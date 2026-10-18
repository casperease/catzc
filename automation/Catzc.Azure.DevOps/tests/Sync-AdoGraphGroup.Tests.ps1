Describe 'Sync-AdoGraphGroup' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:context = [pscustomobject]@{
            Organization = 'https://dev.azure.com/widgetorg'; Project = 'Gadget'
            GraphBase = 'https://vssps.dev.azure.com/widgetorg/_apis/graph'; ScopeDescriptor = 'scp.gadget'
        }
        $script:sync = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Sync-AdoGraphGroup @A }
        }
    }

    BeforeEach {
        $script:groups = @()
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -ne 'Post' -and $Uri -like '*/groups?scopeDescriptor=scp.gadget*' } { $script:groups }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -eq 'Post' } {
            [pscustomobject]@{ displayName = $Body.displayName; descriptor = 'vssgp.new'; originId = 'group-new' }
        }
    }

    It 'creates the group in the project scope when it does not exist' {
        $result = & $script:sync @{ Context = $script:context; Name = 'Widget Approvers'; Description = 'Widgets' }
        $result.Action | Should -Be 'Create'
        $result.Descriptor | Should -Be 'vssgp.new'
        $result.IdentityId | Should -Be 'group-new'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter {
            $Method -eq 'Post' -and $Body.displayName -eq 'Widget Approvers' -and $Body.description -eq 'Widgets'
        }
    }

    It 'finds an existing group by name and leaves it unchanged' {
        $script:groups = @([pscustomobject]@{ displayName = 'Widget Approvers'; descriptor = 'vssgp.g1'; originId = 'group-1' })
        $result = & $script:sync @{ Context = $script:context; Name = 'Widget Approvers'; Description = 'Widgets' }
        $result.Action | Should -Be 'Unchanged'
        $result.IdentityId | Should -Be 'group-1'
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -eq 'Post' }
    }

    It 'reports Create but writes nothing with -DryRun' {
        $result = & $script:sync @{ Context = $script:context; Name = 'Widget Approvers'; Description = 'Widgets'; DryRun = $true }
        $result.Action | Should -Be 'Create'
        $result.Descriptor | Should -BeNullOrEmpty
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -eq 'Post' }
    }
}
