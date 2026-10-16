// ---
// catzc:
//   derived:
//     path: infrastructure/templates/foundation/main.bicep
//     name: main
//     filetype: bicep
//     kind: template
//     language: bicep
//     track: infrastructure
//     module: foundation
//     moduletype: bicep
//     relatives:
//       page: docs/references/infrastructure/templates/foundation/main.bicep.md
// ---

param location string = resourceGroup().location

param logAnalyticsName string
param keyVaultName string

@description('The CAF tags on every resource: discovery\'s "require a tag" policy denies an untagged one.')
param tags object

module logAnalytics '../../modules/log-analytics.bicep' = {
  name: 'log-analytics'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
  }
}

module keyVault '../../modules/key-vault.bicep' = {
  name: 'key-vault'
  params: {
    name: keyVaultName
    location: location
    tags: tags
  }
}

output logAnalyticsId string = logAnalytics.outputs.id
output keyVaultId string = keyVault.outputs.id
output keyVaultName string = keyVault.outputs.name
