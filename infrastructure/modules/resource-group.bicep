// ---
// catzc:
//   derived:
//     path: infrastructure/modules/resource-group.bicep
//     name: resource-group
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     module: resource-group
//     moduletype: bicep
//     relatives:
//       page: docs/references/infrastructure/modules/resource-group.bicep.md
// ---

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
