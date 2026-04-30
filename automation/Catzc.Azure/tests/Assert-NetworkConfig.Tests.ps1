Describe 'Assert-NetworkConfig' -Tag 'L0' {
    BeforeAll {
        # Mirrors the four azure.yml environments so the cross-asset integrity checks are satisfied.
        $script:baseConfig = [ordered]@{
            environments = [ordered]@{
                dev     = [ordered]@{ vnet_address_space = '10.10.0.0/16'; default_subnet = '10.10.0.0/24' }
                test    = [ordered]@{ vnet_address_space = '10.20.0.0/16'; default_subnet = '10.20.0.0/24' }
                preprod = [ordered]@{ vnet_address_space = '10.30.0.0/16'; default_subnet = '10.30.0.0/24' }
                prod    = [ordered]@{ vnet_address_space = '10.40.0.0/16'; default_subnet = '10.40.0.0/24' }
            }
        }
    }

    Context 'integrity (shipped network.yml)' -Tag 'integrity' {
        It 'passes for the shipped network.yml' {
            $config = Get-Config -Config network
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $config } | Should -Not -Throw
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        It 'passes for a minimal valid config' {
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } (Copy-Object $baseConfig) } | Should -Not -Throw
        }

        It 'throws when missing the environments key' {
            $bad = [ordered]@{ foo = 'bar' }
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*Missing required*'
        }

        It 'throws when an environment is missing vnet_address_space' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.Remove('vnet_address_space')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*missing 'vnet_address_space'*"
        }

        It 'throws when an environment is missing default_subnet' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.Remove('default_subnet')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*missing 'default_subnet'*"
        }

        It 'throws when a range is not a CIDR' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.vnet_address_space = 'not-a-cidr'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a prefix length is out of range' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.default_subnet = '10.10.0.0/40'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid default_subnet*'
        }

        It 'throws when an address octet is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments.dev.vnet_address_space = '10.999.0.0/16'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a network environment is not defined in azure.yml' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('ghost', [ordered]@{ vnet_address_space = '10.99.0.0/16'; default_subnet = '10.99.0.0/24' })
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*not a defined azure.yml environment*'
        }

        It 'throws when an azure.yml environment has no network entry' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Remove('prod')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*environment 'prod' has no network entry*"
        }

        It 'throws when an environment key is not a valid identifier' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('Bad-Env', [ordered]@{ vnet_address_space = '10.50.0.0/16'; default_subnet = '10.50.0.0/24' })
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*not a valid identifier*'
        }
    }
}
