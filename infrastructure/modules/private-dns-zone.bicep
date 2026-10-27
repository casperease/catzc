@description('Zone name, e.g. privatelink.database.windows.net.')
param name string

@description('Resource ids of the virtual networks to link the zone to.')
param virtualNetworkIds array = []

@description('Register the VM records of the linked VNets in the zone automatically (off for privatelink zones).')
param registrationEnabled bool = false

@description('Resource tags.')
param tags object = {}

resource zone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: name
  location: 'global'
  tags: tags
}

resource links 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = [
  for virtualNetworkId in virtualNetworkIds: {
    parent: zone
    name: last(split(virtualNetworkId, '/'))
    location: 'global'
    tags: tags
    properties: {
      registrationEnabled: registrationEnabled
      virtualNetwork: {
        id: virtualNetworkId
      }
    }
  }
]

output id string = zone.id
output name string = zone.name
