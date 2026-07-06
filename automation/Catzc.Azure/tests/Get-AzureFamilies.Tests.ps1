Describe 'Get-AzureFamilies' -Tag 'L0', 'logic' {
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

    It 'groups every subscription into its derived family' {
        $families = Get-AzureFamilies
        @($families | ForEach-Object { $_.name } | Sort-Object) |
            Should -Be @('acme', 'core', 'cross_shared', 'globex')
    }

    It 'a multi-member family lists all its member subscriptions' {
        $core = @(Get-AzureFamilies | Where-Object { $_.name -eq 'core' })[0]
        @($core.subscriptions | Sort-Object) | Should -Be @('core_lower', 'core_upper')
    }

    It 'a customer family carries the canonical customer key' {
        $acme = @(Get-AzureFamilies | Where-Object { $_.name -eq 'acme' })[0]
        $acme.customer | Should -Be 'acme'
        $globex = @(Get-AzureFamilies | Where-Object { $_.name -eq 'globex' })[0]
        $globex.customer | Should -Be 'globex'
    }

    It 'a non-customer family carries an empty customer' {
        $core = @(Get-AzureFamilies | Where-Object { $_.name -eq 'core' })[0]
        $core.customer | Should -BeNullOrEmpty
    }

    It 'overlays declared families: configuration onto the derived entry' {
        $core = @(Get-AzureFamilies | Where-Object { $_.name -eq 'core' })[0]
        $core.details | Should -Be 'Fixture core family (lower + upper pair)'
    }

    It 'an undeclared family has default (empty) configuration' {
        $acme = @(Get-AzureFamilies | Where-Object { $_.name -eq 'acme' })[0]
        $acme.details | Should -BeNullOrEmpty
    }
}
