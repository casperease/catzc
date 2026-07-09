Describe 'Get-AzureSubscription' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
    # identical every test and no test mutates it, so the cache stays warm (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
    BeforeAll {
        # Redirect the config-assets root to the test fixture so this logic test owns its identity
        # inputs and never depends on the shipped azure.yml.
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns id + tenant for a named subscription' {
        $subscription = Get-AzureSubscription core_lower
        $subscription.name | Should -Be 'core_lower'
        $subscription.id | Should -Match '^[0-9a-f-]{36}$'
        $subscription.tenant | Should -Not -BeNullOrEmpty
        $subscription.tenant.name | Should -Be 'fixtenant'
        $subscription.tenant.id | Should -Match '^[0-9a-f-]{36}$'
    }

    It 'includes the customer for a customer subscription (referenced by key)' {
        (Get-AzureSubscription acme_lower).customer | Should -Be 'acme'
    }

    It 'normalizes a customer referenced by shortcode to its canonical key' {
        # globex_short binds customer 'gx' (the shortcode form); it resolves to the key 'globex'.
        (Get-AzureSubscription globex_short).customer | Should -Be 'globex'
    }

    It 'omits the customer for a non-customer subscription' {
        (Get-AzureSubscription core_lower).customer | Should -BeNullOrEmpty
    }

    It 'resolves each subscription by name' {
        (Get-AzureSubscription core_upper).name | Should -Be 'core_upper'
        (Get-AzureSubscription cross_shared).name | Should -Be 'cross_shared'
        (Get-AzureSubscription acme_upper).customer | Should -Be 'acme'
    }

    It 'rejects an unknown subscription via ValidateScript' {
        { Get-AzureSubscription nonexistent } | Should -Throw
    }
}
