// Reusable bicep module: a Log Analytics workspace. Templates reference it with a relative `module`
// declaration (../../modules/log-analytics.bicep); `az bicep build` inlines it.

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

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
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
