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

@description('Resource-context access: a reader of a resource reads that resource\'s logs without a role on the whole workspace.')
param enableLogAccessUsingOnlyResourcePermissions bool = true

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: enableLogAccessUsingOnlyResourcePermissions
    }
  }
}

output id string = workspace.id
output name string = workspace.name
output customerId string = workspace.properties.customerId
