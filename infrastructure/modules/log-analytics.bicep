// ---
// catzc:
//   derived:
//     path: infrastructure/modules/log-analytics.bicep
//     name: log-analytics
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     module: log-analytics
//     moduletype: bicep
//     relatives:
//       page: docs/references/infrastructure/modules/log-analytics.bicep.md
// ---

@description('Log Analytics workspace name.')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Pricing tier. PerGB2018 is the standard pay-as-you-go SKU.')
param skuName string = 'PerGB2018'

@description('Data retention in days.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

@description('Resource tags (a landing zone that requires a tag denies an untagged workspace).')
param tags object = {}

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
  }
}

output id string = workspace.id
output name string = workspace.name
output customerId string = workspace.properties.customerId
