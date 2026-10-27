Describe 'NetworkConfig' -Tag 'L0' {
    BeforeAll {
        # Fixture environments and subscriptions distinct from the shipped ones, so editing azure.yml never changes these outcomes.
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
                    firewall_sku       = 'Basic'
                    subnets            = [ordered]@{
                        GatewaySubnet                 = '10.0.0.0/27'
                        AzureFirewallSubnet           = '10.0.0.64/26'
                        AzureFirewallManagementSubnet = '10.0.0.128/26'
                        'shared-services'             = '10.0.1.0/24'
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

        It 'throws when an environment vnet is a public or reserved range: <range>' -ForEach @(
            @{ range = '20.10.0.0/16' }
            @{ range = '169.254.0.0/16' }
            @{ range = '127.0.0.0/16' }
            @{ range = '224.0.0.0/16' }
            @{ range = '10.0.0.0/7' }
        ) {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.vnet_address_space = $range
            { & $script:make $bad } | Should -Throw "*'alpha' has vnet_address_space '$range' outside the private ranges*"
        }

        It 'accepts a vnet in each private range' -ForEach @(
            @{ vnet = '10.10.0.0/16'; subnet = '10.10.0.0/24' }
            @{ vnet = '172.16.0.0/16'; subnet = '172.16.0.0/24' }
            @{ vnet = '192.168.0.0/16'; subnet = '192.168.0.0/24' }
        ) {
            $ok = Copy-Object $baseConfig
            $ok.environments.alpha.vnet_address_space = $vnet
            $ok.environments.alpha.default_subnet = $subnet
            { & $script:make $ok } | Should -Not -Throw
        }

        It 'throws when an environment default subnet is outside its vnet' {
            $bad = Copy-Object $baseConfig
            $bad.environments.alpha.default_subnet = '10.11.0.0/24'
            { & $script:make $bad } |
                Should -Throw "*network environment 'alpha' default_subnet '10.11.0.0/24' is not inside*"
        }

        It 'throws when an environment key is not a valid identifier' {
            $bad = Copy-Object $baseConfig
            $bad.environments.Add('Bad-Env',
                [ordered]@{ vnet_address_space = '10.50.0.0/16'; default_subnet = '10.50.0.0/24' })
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

    Context 'logic: the subscription block (fixture configs)' -Tag 'logic', 'ADR-AZ-NETWORK-PERSUBSCRIPTION', 'ADR-AZ-NETWORK-NOOVERLAP' {
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
            @($hub.subnets.Keys) | Should -Be @('GatewaySubnet', 'AzureFirewallSubnet', 'AzureFirewallManagementSubnet', 'shared-services')
            $hub.firewall_sku | Should -Be 'Basic'
            $hub.firewall_private_ip | Should -Be '10.0.0.68' -Because 'Azure assigns the fifth address of 10.0.0.64/26 first'
            $config.subscriptions['gadget_edge'].firewall_private_ip | Should -BeNullOrEmpty
            $config.subscriptions['gadget_edge'].firewall_sku | Should -BeNullOrEmpty
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
            $err.Exception.Message |
                Should -BeLike "*network subscription 'gadget_edge' is missing 'vnet_address_space'*"
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

        It 'throws when a subscription vnet is a public range' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.vnet_address_space = '52.0.0.0/16'
            { & $script:make $bad } | Should -Throw "*network subscription 'widget_core' has vnet_address_space '52.0.0.0/16' outside the private ranges*"
        }

        It 'throws when a vnet or subnet range is not an aligned CIDR' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.vnet_address_space = '10.0.0.0/33'
            $bad.subscriptions.gadget_edge.subnets.alpha = '10.100.1.7/24'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message |
                Should -BeLike "*network subscription 'widget_core' has invalid vnet_address_space '10.0.0.0/33'*"
            $err.Exception.Message |
                Should -BeLike "*network subscription 'gadget_edge' subnet 'alpha' has invalid range '10.100.1.7/24'*"
        }

        It 'throws when a subnet lies outside its vnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.beta = '10.101.2.0/24'
            { & $script:make $bad } |
                Should -Throw "*network subscription 'gadget_edge' subnet 'beta' (10.101.2.0/24) is not inside its vnet_address_space '10.100.0.0/16'*"
        }

        It 'throws when two subnets of one vnet overlap' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.beta = '10.100.1.128/25'
            { & $script:make $bad } |
                Should -Throw "*network subscription 'gadget_edge' subnet 'beta' (10.100.1.128/25) overlaps subnet 'alpha' (10.100.1.0/24)*"
        }

        It 'throws when a subscription vnet overlaps an environment vnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.vnet_address_space = '10.0.0.0/8'
            { & $script:make $bad } |
                Should -Throw "*the vnet of subscription 'widget_core' (10.0.0.0/8) overlaps the vnet of environment 'alpha' (10.10.0.0/16)*"
        }

        It 'throws when the address spaces of two subscriptions overlap' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.vnet_address_space = '10.0.0.0/16'
            $bad.subscriptions.gadget_edge.subnets = [ordered]@{ 'private-endpoints' = '10.0.2.0/24' }
            { & $script:make $bad } |
                Should -Throw "*the vnet of subscription 'gadget_edge' (10.0.0.0/16) overlaps the vnet of subscription 'widget_core' (10.0.0.0/16)*"
        }

        It 'throws when a hub lacks a hub subnet or carries another subnet' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.subnets.Remove('GatewaySubnet')
            $bad.subscriptions.widget_core.subnets.alpha = '10.0.2.0/24'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message |
                Should -BeLike "*network subscription 'widget_core' is a hub without subnet 'GatewaySubnet'*"
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' is a hub with subnet 'alpha'*"
        }

        It 'throws when a hub has no firewall SKU or an unknown one, or a spoke has one' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.widget_core.firewall_sku = 'Premium'
            $bad.subscriptions.gadget_edge.firewall_sku = 'Basic'
            $err = { & $script:make $bad } | Should -Throw -PassThru
            $err.Exception.Message | Should -BeLike "*network subscription 'widget_core' has invalid firewall_sku 'Premium' (must be Basic or Standard)*"
            $err.Exception.Message | Should -BeLike "*network subscription 'gadget_edge' is a spoke with a firewall_sku*"
            $bad.subscriptions.widget_core.Remove('firewall_sku')
            { & $script:make $bad } | Should -Throw "*network subscription 'widget_core' is a hub without a firewall_sku*"
        }

        It 'takes the firewall egress declared once on the type, or the file''s' {
            $config = & $script:make (Copy-Object $baseConfig)
            @($config.firewall_egress.service_tags) | Should -Contain 'AzureMonitor'
            @($config.firewall_egress.fqdn_tags) | Should -Be @('WindowsUpdate')
            $own = Copy-Object $baseConfig
            $own.firewall_egress = [ordered]@{ service_tags = @('AzureMonitor'); fqdn_tags = @() }
            $config = & $script:make $own
            @($config.firewall_egress.service_tags) | Should -Be @('AzureMonitor')
            @($config.firewall_egress.fqdn_tags).Count | Should -Be 0
            $own.firewall_egress = [ordered]@{ ip_ranges = @('0.0.0.0/0') }
            { & $script:make $own } | Should -Throw "*firewall_egress: unknown key 'ip_ranges'*"
        }

        It 'takes the security-group flows declared once on the type, or the file''s, and refuses a bad one' {
            $config = & $script:make (Copy-Object $baseConfig)
            @($config.nsg_flows.name) | Should -Be @('workload-to-private-endpoints', 'shared-services-management', 'same-subnet')
            $own = Copy-Object $baseConfig
            $own.nsg_flows = @([ordered]@{ name = 'widget-https'; to = 'workload'; from = 'workload'; ports = @('443'); protocol = 'Tcp' })
            @((& $script:make $own).nsg_flows.name) | Should -Be @('widget-https')
            $own.nsg_flows = @([ordered]@{ name = 'Widget'; to = 'internet'; from = 'anywhere'; ports = @('x'); protocol = 'Icmp' })
            $err = { & $script:make $own } | Should -Throw -PassThru
            foreach ($part in "invalid name 'Widget'", "invalid to 'internet'", "invalid from 'anywhere'", "invalid protocol 'Icmp'", 'must list its ports') {
                $err.Exception.Message | Should -BeLike "*nsg_flows``[0``]*$part*"
            }
        }

        It 'throws when a spoke lacks private-endpoints' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.Remove('private-endpoints')
            { & $script:make $bad } |
                Should -Throw "*network subscription 'gadget_edge' is a spoke without subnet 'private-endpoints'*"
        }

        It 'throws when a spoke workload subnet is not an environment name' {
            $bad = Copy-Object $baseConfig
            $bad.subscriptions.gadget_edge.subnets.'shared-services' = '10.100.3.0/24'
            { & $script:make $bad } |
                Should -Throw "*network subscription 'gadget_edge' is a spoke with workload subnet 'shared-services'*"
        }
    }

    Context 'no_nsg_subnets' {
        It 'takes Azure''s gateway, firewall and route-server subnets by default, and an override when given' {
            (& $script:make (Copy-Object $baseConfig)).no_nsg_subnets |
                Should -Be @('GatewaySubnet', 'AzureFirewallSubnet', 'AzureFirewallManagementSubnet', 'RouteServerSubnet')
            $override = Copy-Object $baseConfig
            $override['no_nsg_subnets'] = @('GatewaySubnet')
            (& $script:make $override).no_nsg_subnets | Should -Be @('GatewaySubnet')
        }

        It 'refuses an empty override' {
            $bad = Copy-Object $baseConfig
            $bad['no_nsg_subnets'] = @()
            { & $script:make $bad } | Should -Throw '*no_nsg_subnets must be a non-empty list of subnet names*'
        }
    }
}
