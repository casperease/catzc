Describe 'Assert-AzCliConnected' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '50a0ed00-de00-50b0-0000-000000000000'
        $script:tenant = 'fa0e0000-7e0a-0700-1d00-000000000000'
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
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: a2000000-7e57-50b0-0000-000000000000"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -SubscriptionId $script:sub -TenantId $script:tenant } | Should -Throw '*wrong context*'
    }

    It 'tenant-only set: does not throw when in the right tenant' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: a2000000-7e57-50b0-0000-000000000000"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -TenantId $script:tenant } | Should -Not -Throw
    }

    It 'tenant-only set: throws naming the wrong context when the tenant differs' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: a2000000-7e57-7e0a-0700-000000000000`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        { Assert-AzCliConnected -TenantId $script:tenant } | Should -Throw '*wrong context*tenant=*'
    }
}
