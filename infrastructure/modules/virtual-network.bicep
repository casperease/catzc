// Reusable bicep module: a virtual network with a single default subnet. Templates reference it with
// a relative `module` declaration (../../modules/virtual-network.bicep); `az bicep build` inlines it.

@description('Virtual network name.')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Address space CIDR for the virtual network.')
param addressPrefix string = '10.0.0.0/16'

@description('CIDR for the default subnet (must sit within addressPrefix).')
param subnetPrefix string = '10.0.0.0/24'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: subnetPrefix
        }
      }
    ]
  }
}

output id string = vnet.id
output name string = vnet.name
output subnetId string = vnet.properties.subnets[0].id
