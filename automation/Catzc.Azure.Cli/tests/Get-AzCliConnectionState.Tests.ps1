Describe 'Get-AzCliConnectionState' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '00000000-0000-0000-0000-000000000002'
        $script:tenant = '00000000-0000-0000-0000-000000000001'
    }

    It 'reports connected when subscription and tenant both match' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        $state = Get-AzCliConnectionState -SubscriptionId $script:sub -TenantId $script:tenant
        $state.logged_in | Should -BeTrue
        $state.connected | Should -BeTrue
    }

    It 'ignores tenant when -TenantId is omitted (subscription-only match)' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: 99999999-9999-9999-9999-999999999999`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        (Get-AzCliConnectionState -SubscriptionId $script:sub).connected | Should -BeTrue
    }

    It 'is not connected when the tenant differs (and -TenantId is given)' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: 99999999-9999-9999-9999-999999999999`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        (Get-AzCliConnectionState -SubscriptionId $script:sub -TenantId $script:tenant).connected | Should -BeFalse
    }

    It 'is not connected when the subscription differs' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        (Get-AzCliConnectionState -SubscriptionId $script:sub -TenantId $script:tenant).connected | Should -BeFalse
    }

    It 'reports logged_in = false when az account show exits non-zero' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; ExitCode = 1 } } -ModuleName Catzc.Azure.Cli

        $state = Get-AzCliConnectionState -SubscriptionId $script:sub
        $state.logged_in | Should -BeFalse
        $state.connected | Should -BeFalse
    }

    It 'tenant-only set: connected when the tenant matches (subscription ignored)' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        (Get-AzCliConnectionState -TenantId $script:tenant).connected | Should -BeTrue
    }

    It 'tenant-only set: not connected when the tenant differs' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: 99999999-9999-9999-9999-999999999999`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        (Get-AzCliConnectionState -TenantId $script:tenant).connected | Should -BeFalse
    }
}
