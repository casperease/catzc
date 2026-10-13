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
            $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.NetworkConfig]::new($raw) }
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
            $bad.environments.beta.Remove('default_subnet')
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*invalid vnet_address_space*'
            $err.Exception.Message | Should -BeLike "*missing 'default_subnet'*"
        }
    }
}
