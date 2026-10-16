// ---
// catzc:
//   immutable:
//     repo_status: clean
//     path: infrastructure/modules/data-factory.bicep
//     name: data-factory
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     tracktype: infrastructure
//     vendor: azure
//     module: data-factory
//     moduletype: bicep
// ---

@description('Data Factory name (3-24 lowercase alphanumeric, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

resource symbolicname 'Microsoft.DataFactory/factories@2018-06-01' = {
  location: location
  name: name
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}
