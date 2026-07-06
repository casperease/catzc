Describe 'Get-AzureSubscriptionFamily' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
    # identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'derives the family from the customer key for a customer subscription' {
        Get-AzureSubscriptionFamily acme_lower | Should -Be 'acme'
        Get-AzureSubscriptionFamily acme_upper | Should -Be 'acme'
    }

    It 'normalizes a by-shortcode customer binding to the canonical key' {
        # globex_short binds customer 'gx'; the family is the canonical key, whichever form the config used.
        Get-AzureSubscriptionFamily globex_short | Should -Be 'globex'
    }

    It 'uses the explicit family: key for a non-customer group member' {
        Get-AzureSubscriptionFamily core_lower | Should -Be 'core'
        Get-AzureSubscriptionFamily core_upper | Should -Be 'core'
    }

    It 'defaults an ungrouped subscription to its own name (the one-member family)' {
        Get-AzureSubscriptionFamily cross_shared | Should -Be 'cross_shared'
    }

    It 'rejects an unknown subscription via ValidateScript' {
        { Get-AzureSubscriptionFamily nonexistent } | Should -Throw
    }
}
