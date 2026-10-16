// ---
// catzc:
//   derived:
//     path: infrastructure/modules/storage-account.bicep
//     name: storage-account
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     module: storage-account
//     moduletype: bicep
//     relatives:
//       page: docs/references/infrastructure/modules/storage-account.bicep.md
// ---

@description('Storage account name (3-24 lowercase alphanumeric, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Storage SKU name. Standard_ZRS keeps three copies across availability zones; pick an LRS SKU only where the region has no zones.')
param skuName string = 'Standard_ZRS'

@description('Public network access. Disabled by default (and the network rules deny): the account is reached through a private endpoint.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Allow shared-key (account key and SAS) authorization. Off by default: callers authenticate with Entra ID.')
param allowSharedKeyAccess bool = false

@description('Soft-delete retention in days for deleted blobs and containers.')
@minValue(1)
@maxValue(365)
param deleteRetentionDays int = 7

@description('Resource tags.')
param tags object = {}

resource sa 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: allowSharedKeyAccess
    publicNetworkAccess: publicNetworkAccess
    networkAcls: {
      defaultAction: publicNetworkAccess == 'Enabled' ? 'Allow' : 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: sa
  name: 'default'
  properties: {
    deleteRetentionPolicy: {
      enabled: true
      days: deleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: deleteRetentionDays
    }
  }
}

output id string = sa.id
output name string = sa.name
output principalId string = sa.identity.principalId
output blobEndpoint string = sa.properties.primaryEndpoints.blob
