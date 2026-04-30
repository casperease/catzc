Describe 'Assert-AzCliConnected' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '00000000-0000-0000-0000-000000000002'
        $script:tenant = '00000000-0000-0000-0000-000000000001'
    }

    It 'does not throw when connected to the given subscription and tenant' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -SubscriptionId $script:sub -TenantId $script:tenant } | Should -Not -Throw
    }

    It 'throws with an az login hint when not logged in' {
        Mock Invoke-AzCli { [pscustomobject]@{ Output = ''; ExitCode = 1 } } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -SubscriptionId $script:sub } | Should -Throw '*az login*'
    }

    It 'throws naming the wrong context when the subscription differs' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -SubscriptionId $script:sub -TenantId $script:tenant } | Should -Throw '*wrong context*'
    }

    It 'tenant-only set: does not throw when in the right tenant' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -TenantId $script:tenant } | Should -Not -Throw
    }

    It 'tenant-only set: throws naming the wrong context when the tenant differs' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: 99999999-9999-9999-9999-999999999999`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -TenantId $script:tenant } | Should -Throw '*wrong context*tenant=*'
    }
}
