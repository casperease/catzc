@description('Firewall policy name (unique within the resource group).')
param name string

param location string = resourceGroup().location

@description('The tier of the firewall the policy serves; the policy takes the same.')
@allowed([
  'Basic'
  'Standard'
])
param sku string

@description('The workload subnets the egress rules allow traffic from.')
param sourceAddresses array

@description('Service tags allowed outbound, in network rules; a `{region}` in a tag becomes the policy\'s location, so `Storage.{region}` is the regional `Storage.<region>` tag.')
param serviceTags array

@description('FQDN tags allowed outbound over HTTPS, in application rules.')
param fqdnTags array

@description('Resource tags.')
param tags object = {}

resource policy 'Microsoft.Network/firewallPolicies@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      tier: sku
    }
    threatIntelMode: sku == 'Basic' ? 'Alert' : 'Deny'
  }
}

resource egress 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2024-05-01' = {
  parent: policy
  name: 'egress'
  properties: {
    priority: 200
    ruleCollections: concat(
      empty(serviceTags)
        ? []
        : [
            {
              ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
              name: 'platform-services'
              priority: 100
              action: {
                type: 'Allow'
              }
              rules: [
                {
                  ruleType: 'NetworkRule'
                  name: 'platform-service-tags'
                  ipProtocols: [
                    'TCP'
                  ]
                  sourceAddresses: sourceAddresses
                  destinationAddresses: map(serviceTags, serviceTag => replace(serviceTag, '{region}', location))
                  destinationPorts: [
                    '443'
                  ]
                }
              ]
            }
          ],
      empty(fqdnTags)
        ? []
        : [
            {
              ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
              name: 'platform-fqdns'
              priority: 200
              action: {
                type: 'Allow'
              }
              rules: [
                {
                  ruleType: 'ApplicationRule'
                  name: 'platform-fqdn-tags'
                  sourceAddresses: sourceAddresses
                  fqdnTags: fqdnTags
                  protocols: [
                    {
                      protocolType: 'Https'
                      port: 443
                    }
                  ]
                }
              ]
            }
          ]
    )
  }
}

output id string = policy.id
