// Reusable bicep module: a network security group. The caller passes the rules in the ARM
// `securityRules` shape ({ name, properties: { priority, direction, access, protocol, … } }); the
// Azure default rules (allow VNet and load-balancer inbound, deny all other inbound) always apply
// beneath them. Attach it to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build`
// inlines it.

@description('Network security group name (1-80 characters, unique within the resource group).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Security rules, in the ARM securityRules shape.')
param securityRules array = []

@description('Resource tags.')
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

output id string = nsg.id
output name string = nsg.name
