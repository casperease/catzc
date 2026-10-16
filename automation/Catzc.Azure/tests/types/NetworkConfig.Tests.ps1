<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
    folder: tests/types
    name: network-config-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
    adrs:
      - ADR-AUTO-TEST#{1,3}
      - ADR-AZ-NETWORK#{5,6}
---
#>

Describe 'NetworkConfig' -Tag 'L0' {
    BeforeAll {
        $script:baseConfig = [ordered]@{
            environments  = [ordered]@{
                alpha = [ordered]@{ vnet_address_space = '10.10.0.0/16'; default_subnet = '10.10.0.0/24' }
                beta  = [ordered]@{ vnet_address_space = '10.20.0.0/16'; default_subnet = '10.20.0.0/24' }
                gamma = [ordered]@{ vnet_address_space = '10.30.0.0/16'; default_subnet = '10.30.0.0/24' }
                delta = [ordered]@{ vnet_address_space = '10.40.0.0/16'; default_subnet = '10.40.0.0/24' }
            }
            subscriptions = [ordered]@{
                widget_core = [ordered]@{
                    kind               = 'hub'
                    vnet_address_space = '10.0.0.0/16'
                    subnets            = [ordered]@{
                        GatewaySubnet       = '10.0.0.0/27'
                        AzureFirewallSubnet = '10.0.0.64/26'
                        'shared-services'   = '10.0.1.0/24'
                    }
                }
                gadget_edge = [ordered]@{
                    kind               = 'spoke'
                    vnet_address_space = '10.100.0.0/16'
                    subnets            = [ordered]@{
                        'private-endpoints' = '10.100.0.0/24'
                        alpha               = '10.100.1.0/24'
                        beta                = '10.100.2.0/24'
                    }
                }
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

        It 'throws when a range has host bits set' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = '10.10.0.1/16'
            { & $script:make $bad } | Should -Throw '*invalid vnet_address_space*aligned IPv4 CIDR*'
        }

        It 'throws when an environment default subnet is outside its vnet' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.default_subnet = '10.11.0.0/24'
            { & $script:make $bad } | Should -Throw "*network environment 'alpha' default_subnet '10.11.0.0/24' is not inside*"
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
            $bad.subscriptions.gadget_edge.kind = 'leaf'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike '*invalid vnet_address_space*'
            $err.Exception.Message | Should -BeLike "*missing 'default_subnet'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'gadget_edge' has invalid kind 'leaf'*"
        }
    }

    Context 'logic: the subscription block (fixture configs)' -Tag 'logic', 'ADR-AZ-NETWORK#5', 'ADR-AZ-NETWORK#6' {
        BeforeAll {
            $script:make = { param([System.Collections.IDictionary] $raw) [Catzc.Azure.NetworkConfig]::new($raw) }
        }

        It 'loads a hub and a spoke as typed records with their subnets in file order' {
            $config = & $script:make (Copy-Object $baseConfig)
            @($config.subscriptions.Keys) | Should -Be @('widget_core', 'gadget_edge')
            $hub = $config.subscriptions['widget_core']
            $hub | Should -BeOfType [Catzc.Azure.NetworkSubscription]
            $hub.kind | Should -Be 'hub'
            $hub.vnet_address_space | Should -Be '10.0.0.0/16'
            @($hub.subnets.Keys) | Should -Be @('GatewaySubnet', 'AzureFirewallSubnet', 'shared-services')
            $config.subscriptions['gadget_edge'].subnets['private-endpoints'] | Should -Be '10.100.0.0/24'
        }

        It 'renders a subscription as one console line' {
            $config = & $script:make (Copy-Object $baseConfig)
            "$($config.subscriptions['widget_core'])" | Should -BeLike 'NetworkSubscription*widget_core*'
        }

        It 'passes without a subscriptions key, with an empty map' {
            $config = Copy-Object $baseConfig
            $config.Remove('subscriptions')
            (& $script:make $config).subscriptions.Count | Should -Be 0
        }

        It 'throws when subscriptions is present but empty' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions = [ordered]@{}
            { & $script:make $bad } | Should -Throw '*subscriptions is empty*'
        }

        It 'throws when a subscription is missing its kind, vnet or subnets' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.Remove('kind')
            $bad.subscriptions.gadget_edge.Remove('vnet_address_space')
            $bad.subscriptions.gadget_edge.Remove('subnets')
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' is missing 'kind'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'gadget_edge' is missing 'vnet_address_space'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'gadget_edge' is missing 'subnets'*"
        }

        It 'throws when a subscription name is not a valid identifier' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.Add('Bad-Sub', (Copy-Object $baseConfig.subscriptions.gadget_edge))
            $bad.subscriptions.Remove('gadget_edge')
            { & $script:make $bad } | Should -Throw "*network subscription 'Bad-Sub' is not a valid identifier*"
        }

        It 'throws on an unknown key in a subscription' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.peers = 'gadget_edge'
            { & $script:make $bad } | Should -Throw "*network subscription 'widget_core': unknown key 'peers'*"
        }

        It 'throws when a vnet or subnet range is not an aligned CIDR' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.vnet_address_space = '10.0.0.0/33'
            $bad.subscriptions.gadget_edge.subnets.alpha = '10.100.1.7/24'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' has invalid vnet_address_space '10.0.0.0/33'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'gadget_edge' subnet 'alpha' has invalid range '10.100.1.7/24'*"
        }

        It 'throws when a subnet lies outside its vnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.beta = '10.101.2.0/24'
            { & $script:make $bad } | Should -Throw "*network subscription 'gadget_edge' subnet 'beta' (10.101.2.0/24) is not inside its vnet_address_space '10.100.0.0/16'*"
        }

        It 'throws when two subnets of one vnet overlap' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.beta = '10.100.1.128/25'
            { & $script:make $bad } | Should -Throw "*network subscription 'gadget_edge' subnet 'beta' (10.100.1.128/25) overlaps subnet 'alpha' (10.100.1.0/24)*"
        }

        It 'throws when a subscription vnet overlaps an environment vnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.vnet_address_space = '10.0.0.0/8'
            { & $script:make $bad } | Should -Throw "*the vnet of subscription 'widget_core' (10.0.0.0/8) overlaps the vnet of environment 'alpha' (10.10.0.0/16)*"
        }

        It 'throws when the address spaces of two subscriptions overlap' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.vnet_address_space = '10.0.0.0/16'
            $bad.subscriptions.gadget_edge.subnets = [ordered]@{ 'private-endpoints' = '10.0.2.0/24' }
            { & $script:make $bad } | Should -Throw "*the vnet of subscription 'gadget_edge' (10.0.0.0/16) overlaps the vnet of subscription 'widget_core' (10.0.0.0/16)*"
        }

        It 'throws when a hub lacks a hub subnet or carries another subnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.subnets.Remove('GatewaySubnet')
            $bad.subscriptions.widget_core.subnets.alpha = '10.0.2.0/24'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' is a hub without subnet 'GatewaySubnet'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' is a hub with subnet 'alpha'*"
        }

        It 'throws when a spoke lacks private-endpoints' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.Remove('private-endpoints')
            { & $script:make $bad } | Should -Throw "*network subscription 'gadget_edge' is a spoke without subnet 'private-endpoints'*"
        }

        It 'throws when a spoke workload subnet is not an environment name' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.'shared-services' = '10.100.3.0/24'
            { & $script:make $bad } | Should -Throw "*network subscription 'gadget_edge' is a spoke with workload subnet 'shared-services'*"
        }
    }
}
