Describe 'Get-AzureCustomers' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
    # identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the customer keys from customer.yml' {
        $customers = Get-AzureCustomers
        $customers | Should -Contain 'acme'
        $customers | Should -Contain 'globex'
    }

    It 'returns all fixture customers' {
        @(Get-AzureCustomers).Count | Should -Be 2
    }
}
