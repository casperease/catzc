@description('Storage account name (3-24 lowercase alphanumeric, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Storage SKU name. Standard_ZRS keeps three copies across availability zones, for production; Standard_LRS keeps three in one datacenter, for a non-production environment or a region with no zones.')
param skuName string = 'Standard_ZRS'

@description('The default access tier of new blobs.')
@allowed([
  'Hot'
  'Cool'
])
param accessTier string = 'Hot'

@description('Days since a blob was last modified before the lifecycle policy moves it to the cool tier; 0 turns the move off.')
@minValue(0)
param coolAfterDays int = 0

@description('Days since a blob was last modified before the lifecycle policy moves it to the archive tier; 0 turns the move off.')
@minValue(0)
param archiveAfterDays int = 0

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

resource sa 'Microsoft.Storage/storageAccounts@2024-01-01' = {
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
    accessTier: accessTier
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

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
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

// The tiering rule exists only when a move is set, so an account with both ages at 0 carries no lifecycle policy.
var tierActions = union(
  coolAfterDays > 0 ? { tierToCool: { daysAfterModificationGreaterThan: coolAfterDays } } : {},
  archiveAfterDays > 0 ? { tierToArchive: { daysAfterModificationGreaterThan: archiveAfterDays } } : {}
)

resource lifecycle 'Microsoft.Storage/storageAccounts/managementPolicies@2024-01-01' = if (coolAfterDays > 0 || archiveAfterDays > 0) {
  parent: sa
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'tier-by-age'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: {
              blobTypes: [
                'blockBlob'
              ]
            }
            actions: {
              baseBlob: tierActions
            }
          }
        }
      ]
    }
  }
}

output id string = sa.id
output name string = sa.name
output principalId string = sa.identity.principalId
output blobEndpoint string = sa.properties.primaryEndpoints.blob
