Describe 'NetworkConfig' -Tag 'L0' {
    BeforeAll {
        # Fixture network plan — deliberately-distinct Greek env names (alpha/beta/gamma/delta), NOT the
        # shipped dev/test/preprod/prod, so this logic test owns its identity inputs and editing azure.yml
        # can never change its outcome ([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1),
        # [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
        $script:baseConfig = [ordered]@{
            environments = [ordered]@{
                alpha = [ordered]@{ vnet_address_space = '10.10.0.0/16'; default_subnet = '10.10.0.0/24' }
                beta  = [ordered]@{ vnet_address_space = '10.20.0.0/16'; default_subnet = '10.20.0.0/24' }
                gamma = [ordered]@{ vnet_address_space = '10.30.0.0/16'; default_subnet = '10.30.0.0/24' }
                delta = [ordered]@{ vnet_address_space = '10.40.0.0/16'; default_subnet = '10.40.0.0/24' }
            }
        }
    }

    Context 'integrity (shipped network.yml)' -Tag 'integrity' {
        It 'passes for the shipped network.yml' {
            Get-Config -Config network | Should -BeOfType [Catzc.Azure.NetworkConfig]
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            # The type cross-checks the network plan against azure.yml's environments. The two-argument
            # constructor takes a fixture azure config with the SAME Greek env set, so the logic test is hermetic
            # — it does not depend on which environments the shipped azure.yml happens to declare today.
            $environment = { param($code) [ordered]@{ shortcode = $code; region = 'westeurope'; region_code = 'weu' } }
            $script:fixtureAzure = [Catzc.Azure.AzureConfig]::new([ordered]@{
                    org               = 'tst'
                    bicep_min_version = '0.30.0'
                    tenants           = [ordered]@{ fixtenant = [ordered]@{ id = 'fa0e0000-7e0a-0700-1d00-000000000000' } }
                    subscriptions     = [ordered]@{
                        core_lower = [ordered]@{ id = '50a0ed00-de00-50b0-0000-000000000000'; tenant = 'fixtenant'; environments = @('alpha') }
                    }
                    environments      = [ordered]@{
                        alpha = (& $environment 'al')
                        beta  = (& $environment 'bt')
                        gamma = (& $environment 'gm')
                        delta = (& $environment 'dl')
                        nsub  = [ordered]@{ shortcode = 'ns'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                        psub  = [ordered]@{ shortcode = 'ps'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                    }
                })
            $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.NetworkConfig]::new($raw, $script:fixtureAzure) }
        }

        It 'passes for a minimal valid config' {
            $config = & $script:make (Copy-Object $baseConfig)
            @($config.environments.Keys) | Should -Be @('alpha', 'beta', 'gamma', 'delta')
            $config.environments['alpha'] | Should -BeOfType [Catzc.Azure.NetworkEnvironment]
            $config.environments['alpha'].vnet_address_space | Should -Be '10.10.0.0/16'
            $config.environments.beta.default_subnet | Should -Be '10.20.0.0/24'
        }

        It 'throws when missing the environments key' {
            { & $script:make ([ordered]@{ foo = 'bar' }) } | Should -Throw '*Missing required*'
        }

        It 'throws when an environment is missing vnet_address_space' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('vnet_address_space')
            { & $script:make $bad } | Should -Throw "*missing 'vnet_address_space'*"
        }

        It 'throws when an environment is missing default_subnet' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('default_subnet')
            { & $script:make $bad } | Should -Throw "*missing 'default_subnet'*"
        }

        It 'throws when a range is not a CIDR' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = 'not-a-cidr'
            { & $script:make $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a prefix length is out of range' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.default_subnet = '10.10.0.0/40'
            { & $script:make $bad } | Should -Throw '*invalid default_subnet*'
        }

        It 'throws when an address octet is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = '10.999.0.0/16'
            { & $script:make $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a network environment is not defined in azure.yml' -Tag 'ADR-AZ-NETWORK#2' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('ghost', [ordered]@{ vnet_address_space = '10.99.0.0/16'; default_subnet = '10.99.0.0/24' })
            { & $script:make $bad } | Should -Throw '*not a defined azure.yml environment*'
        }

        It 'throws when an azure.yml environment has no network entry' -Tag 'ADR-AZ-NETWORK#2' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Remove('delta')
            { & $script:make $bad } | Should -Throw "*environment 'delta' has no network entry*"
        }

        It 'throws when an environment key is not a valid identifier' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('Bad-Env', [ordered]@{ vnet_address_space = '10.50.0.0/16'; default_subnet = '10.50.0.0/24' })
            { & $script:make $bad } | Should -Throw '*not a valid identifier*'
        }

        It 'throws on an unknown top-level or entry key' {
            $bad = Copy-Object $baseConfig
            $bad.extra = 1
            $bad.environments.alpha.gateway = '10.10.0.1'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*network.yml: unknown key 'extra'*"
            $err.Exception.Message | Should -BeLike "*network environment 'alpha': unknown key 'gateway'*"
        }

        It 'reports every violation in one throw' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = 'not-a-cidr'
            $bad.environments.Remove('delta')
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*invalid vnet_address_space*'
            $err.Exception.Message | Should -BeLike "*environment 'delta' has no network entry*"
        }
    }

    Context 'logic (registry path reads the session azure config)' -Tag 'logic' {
        It 'checks the plan against Get-Config -Config azure when given no azure config' {
            # The fixture azure.yml/network.yml pair (Greek envs) through the discovery seam.
            Mock Resolve-ConfigEntry -ModuleName Catzc.Base.Config -ParameterFilter { $Config -in 'azure', 'network' } -MockWith {
                @{ Name = $Config; Module = 'Catzc.Azure'
                    Path = Join-Path (Get-RepositoryRoot) "automation/Catzc.Azure/tests/assets/config/$Config.yml"
                }
            }
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
            (Get-Config -Config network).environments.Keys | Should -Contain 'alpha'
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('ghost', [ordered]@{ vnet_address_space = '10.99.0.0/16'; default_subnet = '10.99.0.0/24' })
            { InModuleScope Catzc.Base.Config -Parameters @{ Raw = $bad } { [Catzc.Azure.NetworkConfig]::new($Raw) } } |
                Should -Throw "*network environment 'ghost' is not a defined azure.yml environment*"
            InModuleScope Catzc.Base.Config { $script:configCache = $null }
        }
    }
}
