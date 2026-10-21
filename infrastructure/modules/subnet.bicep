// ---
// catzc:
//   immutable:
//     with_body_sha: b74d01d6eb90
//   edges:
//     docs: "[subnet.bicep.md](../../docs/references/infrastructure/modules/subnet.bicep.md)"
// ---

@description('Name of the existing virtual network (in the deployment resource group).')
param virtualNetworkName string

@description('Subnet name (1-80 characters, unique within the VNet).')
param name string

@description('Subnet CIDR (must sit within the VNet address space).')
param addressPrefix string

@description('Resource id of the network security group to attach. Empty attaches none.')
param networkSecurityGroupId string = ''

@description('Resource id of the route table to attach. Empty attaches none.')
param routeTableId string = ''

@description('Apply network security group and route table rules to private endpoints in the subnet.')
@allowed([
  'Enabled'
  'Disabled'
  'NetworkSecurityGroupEnabled'
  'RouteTableEnabled'
])
param privateEndpointNetworkPolicies string = 'Enabled'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: virtualNetworkName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: vnet
  name: name
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: empty(networkSecurityGroupId) ? null : { id: networkSecurityGroupId }
    routeTable: empty(routeTableId) ? null : { id: routeTableId }
    privateEndpointNetworkPolicies: privateEndpointNetworkPolicies
  }
}

output id string = subnet.id
output name string = subnet.name
