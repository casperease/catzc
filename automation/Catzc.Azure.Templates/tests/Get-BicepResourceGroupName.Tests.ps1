Describe 'Get-BicepResourceGroupName' -Tag 'L0', 'logic' {
    # Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
    # config is identical every test and no test mutates it, so the cache stays warm (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network', 'customer' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'derives env-region-org-short-rg for a base slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample -Environment alpha } |
            Should -Be 'alpha-weu-tst-smpl-rg'
    }

    It 'includes the slot for a special slot' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-indexed -Environment alpha -Slot 001 } |
            Should -Be 'alpha-001-weu-tst-sidx-rg'
    }

    It 'includes the customer (readable key) for a per-customer RG' {
        & (Get-Module Catzc.Azure.Templates) { Get-BicepResourceGroupName -Template sample-customer -Environment alpha -Customer acme } |
            Should -Be 'alpha-weu-tst-scus-acme-rg'
    }
}
