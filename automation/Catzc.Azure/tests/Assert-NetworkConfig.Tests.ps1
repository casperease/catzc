Describe 'Assert-NetworkConfig' -Tag 'L0' {
    BeforeAll {
        # Fixture network plan — deliberately-distinct Greek env names (alpha/beta/gamma/delta), NOT the
        # shipped dev/test/preprod/prod, so this logic test owns its identity inputs and editing azure.yml
        # can never change its outcome (ADR-TEST:1, ADR-TEST:3).
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
            $config = Get-Config -Config network
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $config } | Should -Not -Throw
        }
    }

    Context 'logic (fixture configs)' -Tag 'logic' {
        BeforeAll {
            # Assert-NetworkConfig cross-checks the network plan against azure.yml's environments. Mock that
            # read to a fixture azure config with the SAME Greek env set, so the logic test is hermetic — it
            # does not depend on which environments the shipped azure.yml happens to declare today.
            $script:fixtureAzure = [ordered]@{
                environments = [ordered]@{
                    alpha = [ordered]@{ shortcode = 'al'; region = 'westeurope'; region_code = 'weu' }
                    beta  = [ordered]@{ shortcode = 'bt'; region = 'westeurope'; region_code = 'weu' }
                    gamma = [ordered]@{ shortcode = 'gm'; region = 'westeurope'; region_code = 'weu' }
                    delta = [ordered]@{ shortcode = 'dl'; region = 'westeurope'; region_code = 'weu' }
                    nsub  = [ordered]@{ shortcode = 'sn'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                    psub  = [ordered]@{ shortcode = 'sp'; region = 'westeurope'; region_code = 'weu'; per_subscription = $true }
                }
            }
            Mock Get-Config { $script:fixtureAzure } -ParameterFilter { $Config -eq 'azure' } -ModuleName Catzc.Azure
        }

        It 'passes for a minimal valid config' {
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } (Copy-Object $baseConfig) } | Should -Not -Throw
        }

        It 'throws when missing the environments key' {
            $bad = [ordered]@{ foo = 'bar' }
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*Missing required*'
        }

        It 'throws when an environment is missing vnet_address_space' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('vnet_address_space')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*missing 'vnet_address_space'*"
        }

        It 'throws when an environment is missing default_subnet' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.Remove('default_subnet')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*missing 'default_subnet'*"
        }

        It 'throws when a range is not a CIDR' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = 'not-a-cidr'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a prefix length is out of range' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.default_subnet = '10.10.0.0/40'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid default_subnet*'
        }

        It 'throws when an address octet is invalid' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = '10.999.0.0/16'
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*invalid vnet_address_space*'
        }

        It 'throws when a network environment is not defined in azure.yml' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('ghost', [ordered]@{ vnet_address_space = '10.99.0.0/16'; default_subnet = '10.99.0.0/24' })
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*not a defined azure.yml environment*'
        }

        It 'throws when an azure.yml environment has no network entry' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Remove('delta')
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw "*environment 'delta' has no network entry*"
        }

        It 'throws when an environment key is not a valid identifier' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('Bad-Env', [ordered]@{ vnet_address_space = '10.50.0.0/16'; default_subnet = '10.50.0.0/24' })
            { & (Get-Module Catzc.Azure) { Assert-NetworkConfig $args[0] } $bad } | Should -Throw '*not a valid identifier*'
        }
    }
}
