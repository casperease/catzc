<#
---
catzc:
  immutable:
    with_body_sha: "7fd00e35a221"
  edges:
    code: pwsh/Catzc.Azure.DevOps/private/Sync-AdoGraphGroupMembers.ps1
---
#>

Describe 'Sync-AdoGraphGroupMembers' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:context = [pscustomobject]@{ Organization = 'https://dev.azure.com/widgetorg'; GraphBase = 'https://vssps.dev.azure.com/widgetorg/_apis/graph' }
        $script:sync = {
            param([hashtable] $Arguments)
            InModuleScope Catzc.Azure.DevOps -Parameters @{ A = $Arguments } { param($A) Sync-AdoGraphGroupMembers @A }
        }
    }

    BeforeEach {
        $script:current = @()
        Mock Write-Message -ModuleName Catzc.Azure.DevOps { }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/subjectquery?*' } {
            [pscustomobject]@{ principalName = $Body.query; descriptor = "aad.$($Body.query.Split('@')[0])" }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/Memberships/*direction=Down*' } {
            $script:current | ForEach-Object { [pscustomobject]@{ memberDescriptor = $_ } }
        }
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Method -in 'Put', 'Delete' } { }
    }

    It 'adds the configured members the group lacks and removes the ones the config does not list' {
        $script:current = @('aad.a', 'aad.stale')
        $group = [pscustomobject]@{ Name = 'Widget Approvers'; Descriptor = 'vssgp.g1' }
        $result = & $script:sync @{ Context = $script:context; Group = $group; Member = @('a@widget.test', 'b@widget.test') }
        $result.Added | Should -Be @('b@widget.test')
        $result.Removed | Should -Be @('aad.stale')
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter { $Method -eq 'Put' -and $Uri -like '*/memberships/aad.b/vssgp.g1?*' }
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 1 -Exactly -ParameterFilter { $Method -eq 'Delete' -and $Uri -like '*/memberships/aad.stale/vssgp.g1?*' }
    }

    It 'reports every member as added for a group not created yet, and writes nothing with -DryRun' {
        $group = [pscustomobject]@{ Name = 'Widget Approvers'; Descriptor = $null }
        $result = & $script:sync @{ Context = $script:context; Group = $group; Member = @('a@widget.test'); DryRun = $true }
        $result.Added | Should -Be @('a@widget.test')
        Should -Invoke Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -Times 0 -Exactly -ParameterFilter { $Method -in 'Put', 'Delete' }
    }

    It 'throws, naming the member, when a configured member is not a user of the organization' {
        Mock Invoke-AdoRestMethod -ModuleName Catzc.Azure.DevOps -ParameterFilter { $Uri -like '*/subjectquery?*' } { }
        $group = [pscustomobject]@{ Name = 'Widget Approvers'; Descriptor = 'vssgp.g1' }
        { & $script:sync @{ Context = $script:context; Group = $group; Member = @('ghost@widget.test') } } |
            Should -Throw "*Approver 'ghost@widget.test' is not a user of https://dev.azure.com/widgetorg*"
    }
}
