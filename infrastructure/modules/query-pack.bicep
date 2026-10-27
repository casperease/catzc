@description('Query pack name (unique within the resource group).')
param name string

param location string = resourceGroup().location

@description('The saved queries, each { displayName, description, body }; a query is named by a GUID derived from its display name.')
param queries array

@description('Resource tags.')
param tags object = {}

resource queryPack 'Microsoft.OperationalInsights/queryPacks@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource query 'Microsoft.OperationalInsights/queryPacks/queries@2023-09-01' = [
  for item in queries: {
    parent: queryPack
    name: guid(queryPack.id, item.displayName)
    properties: {
      displayName: item.displayName
      description: item.description
      body: item.body
      related: {
        categories: [
          'monitor'
        ]
      }
    }
  }
]

output id string = queryPack.id
