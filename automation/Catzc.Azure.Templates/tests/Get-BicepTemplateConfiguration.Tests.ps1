# cspell:ignore alweutstscusacst alweutstscusst
Describe 'Get-BicepTemplateConfiguration' -Tag 'L0', 'logic' {
    # Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
    # config is identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
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

    It 'loads alpha configuration with a ParametersFile' {
        $configuration = Get-BicepTemplateConfiguration sample alpha
        $configuration.ParametersFile | Should -Not -BeNullOrEmpty
        $configuration.ParametersFile.Contains('parameters') | Should -BeTrue
    }

    It 'loads beta configuration' {
        $configuration = Get-BicepTemplateConfiguration sample beta
        $configuration.ParametersFile.Contains('parameters') | Should -BeTrue
    }

    It 'throws on an environment not in the template list' {
        { Get-BicepTemplateConfiguration sample nonexistent } | Should -Throw
    }

    It 'throws when the selected slot does not exist' {
        # sample has base slots alpha/beta; asking for slot 001 resolves to config 'alpha-001', which it lacks.
        { Get-BicepTemplateConfiguration sample alpha -Slot 001 } | Should -Throw "*no config 'alpha-001'*"
    }

    It 'throws on an unknown template' {
        { Get-BicepTemplateConfiguration nonexistent alpha } | Should -Throw
    }

    It 'loads a config from the customer subfolder' {
        $configuration = Get-BicepTemplateConfiguration sample-customer alpha -Customer acme
        $configuration.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweutstscusacst'
    }

    It 'loads the configuration-root config distinct from the customer one' {
        $shared = Get-BicepTemplateConfiguration sample-customer alpha
        $shared.ParametersFile.parameters.storageAccountName.value | Should -Be 'alweutstscusst'
    }

    It 'throws when the config does not exist for that customer' {
        # acme has alpha (base) but no slot 002.
        { Get-BicepTemplateConfiguration sample-customer alpha -Slot 002 -Customer acme } |
            Should -Throw '*alpha-002*'
    }
}
