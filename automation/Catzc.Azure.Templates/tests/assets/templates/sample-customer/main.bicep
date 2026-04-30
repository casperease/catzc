// Fixture: an RG-scoped template exercising the per-customer config dimension. It has a core
// (no-customer) config directly under configuration/, and a `acme` customer subdir
// (configuration/acme/) with its own slots — each a distinct resource group deployed into acme's
// subscription. Exercises the customer discovery / config / naming path.
//
// One parameter: storageAccountName. Configured per (customer, env, slot) in
// configuration/[<customer>/]<env>[-<slot>].yml.

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
