// ---
// catzc:
//   derived:
//     path: infrastructure/modules/nsg.bicep
//     kind: template
//     subkind: module
//     language: bicep
//     filekind: bicep
//     track: infrastructure
//     relatives:
//       page: docs/references/infrastructure/modules/nsg.bicep.md
// ---

@description('Network security group name (1-80 characters, unique within the resource group).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Security rules, in the ARM securityRules shape.')
param securityRules array = []

@description('Resource tags.')
param tags object = {}

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

output id string = nsg.id
output name string = nsg.name
