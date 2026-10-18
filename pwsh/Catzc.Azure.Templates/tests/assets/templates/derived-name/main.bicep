// Fixture template with NO options.yml — its short_name is DERIVED from the folder name
// ('derived-name' -> 'deriv') by Get-BicepTemplates via [Catzc.Azure.Templates.BicepShortName]::Resolve.
// Trivial RG-scoped template (one storage account), same shape as the 'sample' fixture.

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
