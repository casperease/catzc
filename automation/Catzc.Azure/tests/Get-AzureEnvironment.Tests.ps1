Describe 'Get-AzureEnvironment' -Tag 'L0', 'logic' {
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

    It 'returns name, shortcode, region, region_code, subscription for alpha' {
        $env = Get-AzureEnvironment alpha -Subscription core_lower
        $env.name | Should -Be 'alpha'
        $env.shortcode | Should -Be 'al'
        $env.region | Should -Be 'westeurope'
        $env.region_code | Should -Be 'weu'
        $env.subscription | Should -Not -BeNullOrEmpty
    }

    It 'returns the correct shortcode for each environment' {
        (Get-AzureEnvironment beta -Subscription core_lower).shortcode | Should -Be 'bt'
        (Get-AzureEnvironment gamma -Subscription core_upper).shortcode | Should -Be 'gm'
        (Get-AzureEnvironment delta -Subscription core_upper).shortcode | Should -Be 'dl'
    }

    It 'embeds the named subscription via Get-AzureSubscription' {
        $env = Get-AzureEnvironment alpha -Subscription core_lower
        $env.subscription.name | Should -Be 'core_lower'
        $env.subscription.tenant.name | Should -Be 'fixtenant'
    }

    It 'embeds a customer subscription, exposing its customer' {
        $env = Get-AzureEnvironment alpha -Subscription acme_lower
        $env.name | Should -Be 'alpha'
        $env.subscription.name | Should -Be 'acme_lower'
        $env.subscription.customer | Should -Be 'acme'
    }

    It 'throws when the subscription does not serve the environment' {
        { Get-AzureEnvironment gamma -Subscription core_lower } | Should -Throw '*does not serve*'
    }

    It 'rejects an unknown environment via ValidateScript' {
        { Get-AzureEnvironment nonexistent -Subscription core_lower } | Should -Throw
    }

    It 'rejects an unknown subscription via ValidateScript' {
        { Get-AzureEnvironment alpha -Subscription bogus } | Should -Throw
    }
}
