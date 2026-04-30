Describe 'Get-BicepTemplateSubscriptions' -Tag 'L0', 'logic' {
    # Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
    # config is identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    It 'returns the subscription subfolders configured for a template' {
        @(Get-BicepTemplateSubscriptions 'sample') | Should -Be @('core_lower')
    }

    It 'returns every subscription for a template with core + customer configs' {
        @(Get-BicepTemplateSubscriptions 'sample-customer' | Sort-Object) | Should -Be @('acme_lower', 'core_lower')
    }

    It 'filters to the subscriptions that have a config for an environment' {
        # sample-subenv: subn lives in core_lower, subp in core_upper.
        @(Get-BicepTemplateSubscriptions 'sample-subenv' 'subn') | Should -Be @('core_lower')
        @(Get-BicepTemplateSubscriptions 'sample-subenv' 'subp') | Should -Be @('core_upper')
    }

    It 'returns an empty array (never throws) for an unknown template' {
        @(Get-BicepTemplateSubscriptions 'does-not-exist') | Should -BeNullOrEmpty
    }

    It 'returns an empty array (never throws) when -Template is omitted' {
        @(Get-BicepTemplateSubscriptions) | Should -BeNullOrEmpty
        @(Get-BicepTemplateSubscriptions '') | Should -BeNullOrEmpty
    }
}

Describe 'Subscription ArgumentCompleter wiring' -Tag 'L0', 'logic' {
    # Read-only resolver tests: boundary mocks + config-cache reset run ONCE, not per test — the mocked
    # config is identical every test and no test mutates it, so the cache stays warm (ADR-TEST:19/ADR-TEST:4).
    BeforeAll {
        Mock Get-BicepTemplatesRoot {
            Join-Path (Get-RepositoryRoot) 'automation/Catzc.Azure.Templates/tests/assets/templates'
        } -ModuleName Catzc.Azure.Templates
        Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
            @{ Name = $Config; Module = 'Catzc.Azure.Templates'
                Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure.Templates/tests/assets/config/$Config.yml"
            }
        }
        InModuleScope Catzc.Base.Config { $script:configCache = $null }
    }

    # The deploy/write paths that take a subscription expose the completer over Get-BicepTemplateSubscriptions.
    $commands = @(
        'Deploy-Bicep'
        'Get-BicepDeploymentContext'
        'Get-BicepTemplateConfiguration'
        'Set-BicepTrackingTagSet'
        'Set-BicepTemplateConfiguration'
    )

    It '<_> has an ArgumentCompleter on -Subscription that returns the template subscriptions' -ForEach $commands {
        $attr = (Get-Command $_).Parameters['Subscription'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ArgumentCompleterAttribute] }
        $attr | Should -Not -BeNullOrEmpty

        $results = & $attr.ScriptBlock $null 'Subscription' '' $null @{ Template = 'sample-customer' }
        @($results) | Should -Contain 'acme_lower'
        @($results) | Should -Contain 'core_lower'
    }
}
