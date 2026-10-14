// Reusable bicep module: a virtual network with its subnets declared inline. A virtual network owns its
// subnets: redeploying a VNet whose subnet list omits a subnet tries to delete that subnet, so the VNet a
// template deploys lists every subnet here (subnet.bicep is for adding a subnet to a VNet the template
// does not deploy). Each subnet may carry a network security group (nsg.bicep) and a route table
// (route-table.bicep). Templates reference it with a relative `module` declaration
// (../../modules/virtual-network.bicep); `az bicep build` inlines it.

@description('A subnet of the virtual network.')
type subnetSpec = {
  @description('Subnet name (1-80 characters, unique within the VNet).')
  name: string

  @description('Subnet CIDR (must sit within addressPrefix).')
  addressPrefix: string

  @description('Resource id of the network security group to attach.')
  networkSecurityGroupId: string?

  @description('Resource id of the route table to attach.')
  routeTableId: string?

  @description('Apply network security group and route table rules to private endpoints in the subnet. Defaults to Enabled.')
  privateEndpointNetworkPolicies: ('Enabled' | 'Disabled' | 'NetworkSecurityGroupEnabled' | 'RouteTableEnabled')?
}

@description('Virtual network name (2-64 characters, unique within the resource group).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Address space CIDR for the virtual network.')
param addressPrefix string = '10.0.0.0/16'

@description('The subnets, each within addressPrefix.')
param subnets subnetSpec[] = [
  {
    name: 'default'
    addressPrefix: '10.0.0.0/24'
  }
]

@description('Resource tags.')
param tags object = {}

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      for subnet in subnets: {
        name: subnet.name
        properties: {
          addressPrefix: subnet.addressPrefix
          networkSecurityGroup: empty(subnet.?networkSecurityGroupId ?? '')
            ? null
            : { id: subnet.networkSecurityGroupId! }
          routeTable: empty(subnet.?routeTableId ?? '') ? null : { id: subnet.routeTableId! }
          privateEndpointNetworkPolicies: subnet.?privateEndpointNetworkPolicies ?? 'Enabled'
        }
      }
    ]
  }
}

output id string = vnet.id
output name string = vnet.name

@description('Subnet resource ids, keyed by subnet name.')
output subnetIds object = toObject(vnet.properties.subnets, subnet => subnet.name, subnet => subnet.id)
