// Test fixture module — a StorageV2 account, used only by the sample-with-module fixture's
// `../../modules/storage-account.bicep` reference so the fixture tree is self-contained under
// tests/assets/. `az bicep build` inlines it into the fixture's compiled main.json. Not a production
// module.

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
