// Deploys at subscription scope; resources then go in through modules scoped to the new resource group.
// [comment:1](/docs/references/infrastructure/modules/resource-group.bicep.md#comment1)

targetScope = 'subscription'

@description('Resource group name (1-90 characters, unique within the subscription).')
param name string

@description('Azure region of the resource group (where its metadata lives). Defaults to the deployment location.')
param location string = deployment().location

@description('Resource tags (the CAF tags).')
param tags object = {}

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location: location
  tags: tags
}

output id string = rg.id
output name string = rg.name
output location string = rg.location
