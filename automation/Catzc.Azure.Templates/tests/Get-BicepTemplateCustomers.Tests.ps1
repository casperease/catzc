Describe 'Get-BicepTemplateCustomers' -Tag 'L0', 'logic' {
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

    It 'returns the customer subdirs configured for a template' {
        $customers = Get-BicepTemplateCustomers 'sample-customer'
        $customers | Should -Contain 'acme'
        foreach ($c in $customers) {
            $c | Should -BeOfType [string]
        }
    }

    It 'returns an empty array for a core-only template' {
        @(Get-BicepTemplateCustomers 'sample') | Should -BeNullOrEmpty
    }

    It 'returns an empty array (never throws) for an unknown template' {
        @(Get-BicepTemplateCustomers 'does-not-exist') | Should -BeNullOrEmpty
    }

    It 'returns an empty array (never throws) when -Template is omitted' {
        @(Get-BicepTemplateCustomers) | Should -BeNullOrEmpty
        @(Get-BicepTemplateCustomers '') | Should -BeNullOrEmpty
    }
}

Describe 'Customer ArgumentCompleter wiring' -Tag 'L0', 'logic' {
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

    # The naming and file-addressing paths take -Customer (the deploy paths are session-determined);
    # each exposes the completer over Get-BicepTemplateCustomers.
    $commands = @(
        'Get-BicepResourceName'
        'Get-BicepTemplateConfiguration'
        'Set-BicepTemplateConfiguration'
    )

    It '<_> has an ArgumentCompleter on -Customer that returns the template customers' -ForEach $commands {
        $attr = (Get-Command $_).Parameters['Customer'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] }
        $attr | Should -Not -BeNullOrEmpty

        $results = & $attr.ScriptBlock $null 'Customer' '' $null @{ Template = 'sample-customer' }
        @($results) | Should -Contain 'acme'
    }
}
