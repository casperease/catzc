@description('Data Factory name (3-24 lowercase alphanumeric, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Public network access: off by default, like the Key Vault\'s, so the factory is reached only through a private endpoint.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

resource symbolicname 'Microsoft.DataFactory/factories@2018-06-01' = {
  location: location
  name: name
  properties: {
    publicNetworkAccess: publicNetworkAccess
  }
}
