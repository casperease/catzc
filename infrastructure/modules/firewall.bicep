@description('Firewall name (unique within the resource group).')
param name string

param location string = resourceGroup().location

@description('The firewall tier: Basic or Standard.')
@allowed([
  'Basic'
  'Standard'
])
param sku string

@description('The firewall policy the firewall runs.')
param firewallPolicyId string

@description('The hub network the firewall sits in; it takes the AzureFirewallSubnet and AzureFirewallManagementSubnet there.')
param virtualNetworkName string

@description('Name of the public IP the firewall sends egress from.')
param publicIpName string

@description('Name of the public IP of the firewall\'s management interface, which a Basic firewall requires.')
param managementPublicIpName string

@description('Availability zones of the firewall and its addresses; empty for none.')
param zones array = []

@description('Resource tags.')
param tags object = {}

var withManagement = sku == 'Basic'

resource publicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: publicIpName
  location: location
  tags: tags
  zones: zones
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource managementPublicIp 'Microsoft.Network/publicIPAddresses@2024-05-01' = if (withManagement) {
  name: managementPublicIpName
  location: location
  tags: tags
  zones: zones
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2024-05-01' = {
  name: name
  location: location
  tags: tags
  zones: zones
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: sku
    }
    firewallPolicy: {
      id: firewallPolicyId
    }
    ipConfigurations: [
      {
        name: 'egress'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, 'AzureFirewallSubnet')
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    managementIpConfiguration: withManagement
      ? {
          name: 'management'
          properties: {
            subnet: {
              id: resourceId(
                'Microsoft.Network/virtualNetworks/subnets',
                virtualNetworkName,
                'AzureFirewallManagementSubnet'
              )
            }
            publicIPAddress: {
              id: managementPublicIp.id
            }
          }
        }
      : null
  }
}

output id string = firewall.id
output name string = firewall.name
