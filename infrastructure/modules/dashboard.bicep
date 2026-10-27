@description('Dashboard name (unique within the resource group).')
param name string

param location string = resourceGroup().location

@description('The dashboard\'s parts, in the shape of one lens\'s parts array.')
param parts array

@description('Resource tags.')
param tags object = {}

resource dashboard 'Microsoft.Portal/dashboards@2025-04-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    lenses: [
      {
        order: 0
        parts: parts
      }
    ]
  }
}

output id string = dashboard.id
