// Trivial RG-scoped sample template. Used by Catzc.Azure.Templates tests + as the
// build/deploy fixture.
//
// One parameter: storageAccountName. Configured per slot in
// configuration/<slot>.yml under ParametersFile.parameters.

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
