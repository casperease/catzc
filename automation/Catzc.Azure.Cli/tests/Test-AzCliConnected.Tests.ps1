Describe 'Test-AzCliConnected' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sub = '00000000-0000-0000-0000-000000000002'
        $script:tenant = '00000000-0000-0000-0000-000000000001'
    }

    It 'returns $true when connected to the given subscription and tenant' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: $script:sub"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        Test-AzCliConnected -SubscriptionId $script:sub -TenantId $script:tenant | Should -BeTrue
    }

    It 'returns $false on a mismatch (never throws)' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        Test-AzCliConnected -SubscriptionId $script:sub -TenantId $script:tenant | Should -BeFalse
    }

    It 'tenant-only set: returns $true when in the right tenant' {
        Mock Invoke-AzCli {
            [pscustomobject]@{ Output = "tenantId: $script:tenant`nid: 88888888-8888-8888-8888-888888888888"; ExitCode = 0 }
        } -ModuleName Catzc.Azure.Cli

        Test-AzCliConnected -TenantId $script:tenant | Should -BeTrue
    }
}
