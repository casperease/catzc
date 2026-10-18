// Fixture: an RG-scoped template whose config files carry a slot (`alpha-001.yml`, `alpha-002.yml`) —
// each is a distinct slot (one resource group), two parallel slots of the same environment. Exercises
// the slot discovery/build path.
//
// One parameter: storageAccountName. Configured per slot in configuration/<env>[-<slot>].yml.

param storageAccountName string
param location string = resourceGroup().location

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

output storageAccountId string = sa.id
