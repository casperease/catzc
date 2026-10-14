// Reusable bicep module: a route table (user-defined routes). The caller passes the routes in the ARM
// `routes` shape ({ name, properties: { addressPrefix, nextHopType, nextHopIpAddress? } }). Attach it
// to a subnet through virtual-network.bicep or subnet.bicep. `az bicep build` inlines it.

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

resource routeTable 'Microsoft.Network/routeTables@2023-09-01' = {
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
