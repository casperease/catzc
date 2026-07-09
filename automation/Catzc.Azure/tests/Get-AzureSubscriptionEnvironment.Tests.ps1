Describe 'Get-AzureSubscriptionEnvironment' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the config mock + cache reset run ONCE, not per test — the mocked config is
    # identical every test and no test mutates it, so the cache stays warm (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
    BeforeAll {
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'resolves the nonprod identity env (nsub) for a nonprod subscription' {
        Get-AzureSubscriptionEnvironment core_lower | Should -Be 'nsub'
        Get-AzureSubscriptionEnvironment acme_lower | Should -Be 'nsub'
    }

    It 'resolves the prod identity env (psub) for a prod subscription' {
        Get-AzureSubscriptionEnvironment core_upper | Should -Be 'psub'
        Get-AzureSubscriptionEnvironment acme_upper | Should -Be 'psub'
    }

    It 'resolves the identity env of a single-subscription that serves all standard envs' {
        # cross_shared serves all standard envs + psub as its one identity env.
        Get-AzureSubscriptionEnvironment cross_shared | Should -Be 'psub'
    }

    It 'rejects an unknown subscription via ValidateScript' {
        { Get-AzureSubscriptionEnvironment nonexistent } | Should -Throw
    }
}
