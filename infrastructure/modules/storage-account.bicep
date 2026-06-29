// Reusable bicep module: a StorageV2 account. Templates reference it with a relative `module`
// declaration (e.g. ../../modules/storage-account.bicep from a template's main.bicep). `az bicep
// build` inlines the module into each template's main.json, so nothing from infrastructure/modules/
// ships separately at deploy time.
//
// Modules live in infrastructure/modules/ and are NOT discovered as templates (Get-BicepTemplates
// scans only infrastructure/templates/).

@description('Storage account name (3-24 lowercase alphanumeric, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Storage SKU name.')
param skuName string = 'Standard_LRS'

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
}

output id string = sa.id
output name string = sa.name
