param location string = resourceGroup().location

param logAnalyticsName string
param keyVaultName string

@description('The storage account the virtual networks\' flow logs land in, derived by the PrePost hook; empty deploys none.')
param flowLogStorageAccountName string = ''

var withFlowLogStorage = !empty(flowLogStorageAccountName)

@description('Days a cost export is kept in the cost-exports container before the lifecycle policy deletes it.')
@minValue(1)
param costExportRetentionDays int = 400

@description('The subscription\'s action group, addressed to its Owner role; every alert of the subscription notifies it.')
param actionGroupName string

@description('The Owner role id the action group notifies, roles.yml by config address (options.yml addresses).')
param ownerRoleId string

@description('Days the workspace keeps its logs (30-730): a config value per environment class, longer in production.')
@minValue(30)
@maxValue(730)
param logAnalyticsRetentionInDays int = 30

@description('The CAF tags on every resource: discovery\'s "require a tag" policy denies an untagged one.')
param tags object

@description('Secret names a slot\'s config overrides, one entry at a time, over the defaults below; consumers read the merged names from the output.')
param secretNames object = {}

// The vault's secret names, declared once; a configuration overrides an entry through secretNames.
var defaultSecretNames = {
  sqlAdminPassword: 'exped-sql-admin-password'
}

@description('Whether the vault gets its private endpoint. False on the bootstrap pass, which runs before discovery has deployed the network and the hub\'s DNS zone; the next foundation deploy places it.')
param deployKeyVaultPrivateEndpoint bool = true

@description('The vault\'s private endpoint.')
param keyVaultPrivateEndpointName string

@description('The resource group of the virtual network the vault\'s endpoint takes its address from.')
param networkResourceGroupName string

@description('The virtual network the vault\'s endpoint takes its address from.')
param virtualNetworkName string

@description('The subnet the vault\'s endpoint takes its address from: the spoke\'s private-endpoints, or the hub\'s shared-services.')
param privateEndpointSubnetName string = 'private-endpoints'

@description('The subscription of the hub that holds the private DNS zones.')
param privateDnsZoneSubscriptionId string

@description('The resource group of the hub\'s private DNS zones.')
param privateDnsZoneResourceGroupName string

@description('The capacity workbook\'s display name; Azure names the workbook by a GUID derived from it.')
param capacityWorkbookName string

@description('The query pack holding the workspace\'s saved queries.')
param queryPackName string

@description('The subscription\'s monitoring dashboard.')
param dashboardName string

// The capacity queries, declared once: the workbook charts them, the query pack saves them and the dashboard pins the first.
var capacityQueries = [
  {
    displayName: 'Database storage used'
    description: 'The percent of its maximum size each database uses, hourly.'
    body: 'AzureMetrics | where ResourceProvider == "MICROSOFT.SQL" and MetricName == "storage_percent" | summarize max(Maximum) by Resource, bin(TimeGenerated, 1h)'
  }
  {
    displayName: 'Database compute used'
    description: 'The percent of its compute each database uses, hourly.'
    body: 'AzureMetrics | where ResourceProvider == "MICROSOFT.SQL" and MetricName in ("cpu_percent", "dtu_consumption_percent") | summarize max(Maximum) by Resource, bin(TimeGenerated, 1h)'
  }
]

// The workbook charts each capacity query over time.
var capacityWorkbookItems = [
  for (query, index) in capacityQueries: {
    type: 3
    name: 'query-${index}'
    content: {
      version: 'KqlItem/1.0'
      title: query.displayName
      query: query.body
      queryType: 0
      resourceType: 'microsoft.operationalinsights/workspaces'
      visualization: 'timechart'
    }
  }
]

var vaultZoneName = 'privatelink${replace(environment().suffixes.keyvaultDns, '.vault.', '.vaultcore.')}'

module logAnalytics '../../modules/log-analytics.bicep' = {
  name: 'log-analytics'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
    retentionInDays: logAnalyticsRetentionInDays
  }
}

module keyVault '../../modules/key-vault.bicep' = {
  name: 'key-vault'
  params: {
    name: keyVaultName
    location: location
    tags: tags
  }
}

// The flow logs of the subscription's virtual networks: closed to the public, written by Network Watcher as a trusted Azure service.
module flowLogStorage '../../modules/storage-account.bicep' = if (withFlowLogStorage) {
  name: 'flow-log-storage'
  params: {
    name: flowLogStorageAccountName
    location: location
    skuName: 'Standard_LRS'
    // The subscription's cost export (discovery) writes here too, kept apart in its own container with its own retention.
    containers: [
      {
        name: 'cost-exports'
        deleteAfterDays: costExportRetentionDays
      }
    ]
    tags: tags
  }
}

module flowLogStorageDiagnostics '../../modules/diagnostic-setting.bicep' = if (withFlowLogStorage) {
  name: 'flow-log-storage-diagnostics'
  params: {
    resourceKind: 'storageAccount'
    resourceName: flowLogStorageAccountName
    workspaceId: logAnalytics.outputs.id
  }
  dependsOn: [
    flowLogStorage
  ]
}

module flowLogBlobDiagnostics '../../modules/diagnostic-setting.bicep' = if (withFlowLogStorage) {
  name: 'flow-log-blob-diagnostics'
  params: {
    resourceKind: 'blobService'
    resourceName: flowLogStorageAccountName
    workspaceId: logAnalytics.outputs.id
  }
  dependsOn: [
    flowLogStorage
  ]
}

module actionGroup '../../modules/action-group.bicep' = {
  name: 'action-group'
  params: {
    name: actionGroupName
    shortName: 'owner'
    roleIds: [
      ownerRoleId
    ]
    tags: tags
  }
}

// The vault carries a CanNotDelete lock: every template that reads a secret depends on it.
module keyVaultLock '../../modules/lock.bicep' = {
  name: 'key-vault-lock'
  params: {
    resourceKind: 'keyVault'
    resourceName: keyVault.outputs.name
  }
}

// The vault's logs and metrics go to the workspace deployed beside it.
module keyVaultDiagnostics '../../modules/diagnostic-setting.bicep' = {
  name: 'key-vault-diagnostics'
  params: {
    resourceKind: 'keyVault'
    resourceName: keyVault.outputs.name
    workspaceId: logAnalytics.outputs.id
  }
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = if (deployKeyVaultPrivateEndpoint) {
  scope: resourceGroup(networkResourceGroupName)
  name: '${virtualNetworkName}/${privateEndpointSubnetName}'
}

resource vaultZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = if (deployKeyVaultPrivateEndpoint) {
  scope: resourceGroup(privateDnsZoneSubscriptionId, privateDnsZoneResourceGroupName)
  name: vaultZoneName
}

// The closed vault's one way in, registered in the hub's vaultcore zone.
module keyVaultPrivateEndpoint '../../modules/private-endpoint.bicep' = if (deployKeyVaultPrivateEndpoint) {
  name: 'key-vault-private-endpoint'
  params: {
    name: keyVaultPrivateEndpointName
    location: location
    subnetId: privateEndpointSubnet.id
    privateLinkServiceId: keyVault.outputs.id
    groupId: 'vault'
    privateDnsZoneIds: [
      vaultZone.id
    ]
    tags: tags
  }
}

// The capacity views over the workspace, in every slot: the workbook beside the production database's capacity alerts.
module capacityWorkbook '../../modules/workbook.bicep' = {
  name: 'capacity-workbook'
  params: {
    displayName: capacityWorkbookName
    location: location
    workspaceId: logAnalytics.outputs.id
    serializedData: string({
      version: 'Notebook/1.0'
      items: capacityWorkbookItems
    })
    tags: tags
  }
}

module queryPack '../../modules/query-pack.bicep' = {
  name: 'query-pack'
  params: {
    name: queryPackName
    location: location
    queries: capacityQueries
    tags: tags
  }
}

module dashboard '../../modules/dashboard.bicep' = {
  name: 'dashboard'
  params: {
    name: dashboardName
    location: location
    parts: [
      {
        position: {
          x: 0
          y: 0
          colSpan: 6
          rowSpan: 4
        }
        metadata: {
          type: 'Extension/HubsExtension/PartType/MarkdownPart'
          settings: {
            content: {
              settings: {
                title: 'Capacity'
                content: 'The capacity workbook "${capacityWorkbookName}" charts database storage and compute; the query pack "${queryPackName}" saves its queries.'
              }
            }
          }
        }
      }
    ]
    tags: tags
  }
}

output logAnalyticsId string = logAnalytics.outputs.id
output keyVaultId string = keyVault.outputs.id
output keyVaultName string = keyVault.outputs.name
output actionGroupId string = actionGroup.outputs.id
output flowLogStorageAccountId string = flowLogStorage.?outputs.id ?? ''
output secretNames object = union(defaultSecretNames, secretNames)
