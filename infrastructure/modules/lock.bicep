@description('Kind of the locked resource.')
@allowed([
  'virtualNetwork'
  'privateDnsZone'
  'keyVault'
])
param resourceKind string

@description('Name of the locked resource, in this resource group.')
param resourceName string

@description('Lock name (unique per locked resource).')
param name string = 'do-not-delete'

@description('Why the resource is locked, shown to whoever tries to delete it.')
param notes string = 'A shared resource other deployments depend on: remove the lock deliberately before deleting it.'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = if (resourceKind == 'virtualNetwork') {
  name: resourceName
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = if (resourceKind == 'privateDnsZone') {
  name: resourceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (resourceKind == 'keyVault') {
  name: resourceName
}

// CanNotDelete: the resource still changes through a deployment, but no one deletes it without first removing the lock.
var properties = {
  level: 'CanNotDelete'
  notes: notes
}

resource virtualNetworkLock 'Microsoft.Authorization/locks@2020-05-01' = if (resourceKind == 'virtualNetwork') {
  scope: virtualNetwork
  name: name
  properties: properties
}

resource privateDnsZoneLock 'Microsoft.Authorization/locks@2020-05-01' = if (resourceKind == 'privateDnsZone') {
  scope: privateDnsZone
  name: name
  properties: properties
}

resource keyVaultLock 'Microsoft.Authorization/locks@2020-05-01' = if (resourceKind == 'keyVault') {
  scope: keyVault
  name: name
  properties: properties
}
