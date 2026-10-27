@description('Route table name (1-80 characters, unique within the resource group).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Routes, in the ARM routes shape.')
param routes array = []

@description('Stop routes learned over BGP (a VPN or ExpressRoute gateway) from reaching the attached subnets.')
param disableBgpRoutePropagation bool = false

@description('Resource tags.')
param tags object = {}

resource routeTable 'Microsoft.Network/routeTables@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    routes: routes
    disableBgpRoutePropagation: disableBgpRoutePropagation
  }
}

output id string = routeTable.id
output name string = routeTable.name
