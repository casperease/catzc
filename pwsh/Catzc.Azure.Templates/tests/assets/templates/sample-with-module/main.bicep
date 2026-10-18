// Fixture: a module-consuming template. References ../../modules/storage-account.bicep (the fixture
// module under tests/assets/modules/) so `az bicep build` inlines it into main.json — exercising the
// reusable-module path entirely within the test fixture tree.

param storageAccountName string
param location string = resourceGroup().location

module storage '../../modules/storage-account.bicep' = {
  name: 'storage'
  params: {
    name: storageAccountName
    location: location
  }
}

output storageAccountId string = storage.outputs.id
