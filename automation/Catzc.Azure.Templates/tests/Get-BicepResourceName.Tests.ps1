# cspell:ignore alweutstsmplst alweutstsmplacst
Describe 'Get-BicepResourceName' -Tag 'L0', 'logic' {
    # Read-only resolver tests: the boundary mocks and the config-cache reset are set up ONCE, not per test.
    # The mocked config is the same fixture every test and no test mutates it, so Get-Config keys its cache on
    # the fixture path and the first call derives it cold (~80ms) while the rest hit the warm cache — a
    # per-test reset would force that cold re-derive on every test (ADR-AUTO-TEST:19/ADR-AUTO-TEST:4).
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

    It 'generates the relaxed resource-group name (env name) for a base slot' {
        Get-BicepResourceName -Template sample -Environment alpha -Type rg | Should -Be 'alpha-weu-tst-smpl-rg'
    }

    It 'generates the tight storage-account name (shortcode, concatenated, no hyphens)' {
        Get-BicepResourceName -Template sample -Environment alpha -Type st | Should -Be 'alweutstsmplst'
    }

    It 'includes the slot for a special slot' {
        Get-BicepResourceName -Template sample-indexed -Environment alpha -Slot 001 -Type rg |
            Should -Be 'alpha-001-weu-tst-sidx-rg'
    }

    It 'inserts a customer (readable key) and role in a relaxed name' {
        Get-BicepResourceName -Template sample -Environment alpha -Type rg -Customer acme -Role hot |
            Should -Be 'alpha-weu-tst-smpl-acme-hot-rg'
    }

    It 'renders the customer SHORTCODE in a tight (restricted) name' {
        Get-BicepResourceName -Template sample -Environment alpha -Type st -Customer acme |
            Should -Be 'alweutstsmplacst'
    }

    It 'rejects an unknown customer' {
        { Get-BicepResourceName -Template sample -Environment alpha -Type rg -Customer ghost } |
            Should -Throw '*Unknown customer*'
    }

    It 'rejects an unknown resource type' {
        { Get-BicepResourceName -Template sample -Environment alpha -Type zzz } | Should -Throw '*Unknown resource type*'
    }
}
