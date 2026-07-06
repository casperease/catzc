Describe 'Get-AzureFamily' -Tag 'L0', 'logic' {
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

    It 'returns the family record by name' {
        $family = Get-AzureFamily core
        $family.name | Should -Be 'core'
        @($family.subscriptions | Sort-Object) | Should -Be @('core_lower', 'core_upper')
        $family.details | Should -Be 'Fixture core family (lower + upper pair)'
    }

    It 'resolves a customer family by the customer key' {
        (Get-AzureFamily acme).customer | Should -Be 'acme'
    }

    It 'resolves an ungrouped subscription as its own one-member family' {
        @((Get-AzureFamily cross_shared).subscriptions) | Should -Be @('cross_shared')
    }

    It 'throws on an unknown family, naming the valid ones' {
        { Get-AzureFamily nonexistent } | Should -Throw '*Unknown family*nonexistent*'
    }
}
