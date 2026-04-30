Describe 'Test-AzCliIsConnected' -Tag 'L0', 'logic' {
    BeforeAll {
        # Isolate from the shipped azure.yml: resolve identity from the test config fixture.
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Cli/tests/assets/config/$Config.yml"
            }
        }
        $script:sub = Get-AzureSubscription core_lower
        $script:subId = $script:sub.id
        $script:tenantId = $script:sub.tenant.id
    }

    It 'returns $true and delegates with the resolved identity' {
        Mock Test-AzCliConnected { $true } -ModuleName Catzc.Azure.Cli

        Test-AzCliIsConnected core_lower | Should -BeTrue
        Should -Invoke Test-AzCliConnected -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $script:subId -and $TenantId -eq $script:tenantId
        }
    }

    It 'delegates with the customer subscription' {
        $custSub = Get-AzureSubscription acme_lower
        Mock Test-AzCliConnected { $true } -ModuleName Catzc.Azure.Cli

        Test-AzCliIsConnected acme_lower | Should -BeTrue
        Should -Invoke Test-AzCliConnected -ModuleName Catzc.Azure.Cli -ParameterFilter {
            $SubscriptionId -eq $custSub.id
        }
    }

    It 'returns $false when the generic check is false' {
        Mock Test-AzCliConnected { $false } -ModuleName Catzc.Azure.Cli

        Test-AzCliIsConnected core_lower | Should -BeFalse
    }
}
