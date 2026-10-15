// ---
// catzc:
//   derived:
//     path: infrastructure/modules/private-endpoint.bicep
//     kind: bicep-module
//     relatives:
//       page: docs/references/infrastructure/modules/private-endpoint.bicep.md
// ---

@description('Private endpoint name (2-64 characters, unique within the resource group).')
param name string

@description('Azure region. Defaults to the enclosing resource group location; it must match the region of the subnet VNet.')
param location string = resourceGroup().location

@description('Resource id of the subnet the endpoint takes its address from.')
param subnetId string

@description('Resource id of the target service (the storage account, the SQL server, …).')
param privateLinkServiceId string

@description('The target sub-resource (group id): blob, file, sqlServer, vault, ….')
param groupId string

@description('Resource ids of the private DNS zones to register the endpoint in. Empty registers none.')
param privateDnsZoneIds array = []

@description('Resource tags.')
param tags object = {}

resource endpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [
            groupId
          ]
        }
      }
    ]
  }
}

resource zoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-09-01' = if (!empty(privateDnsZoneIds)) {
  parent: endpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      for zoneId in privateDnsZoneIds: {
        name: replace(last(split(zoneId, '/')), '.', '-')
        properties: {
          privateDnsZoneId: zoneId
        }
      }
    ]
  }
}

output id string = endpoint.id
output name string = endpoint.name
