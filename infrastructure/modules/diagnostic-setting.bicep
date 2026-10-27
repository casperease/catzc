@description('Kind of the target resource.')
@allowed([
  'storageAccount'
  'blobService'
  'sqlDatabase'
  'keyVault'
  'networkSecurityGroup'
  'virtualNetwork'
  'azureFirewall'
])
param resourceKind string

@description('Name of the target resource (for blobService the storage account; for sqlDatabase the database).')
param resourceName string

@description('Name of the parent resource: the SQL server for sqlDatabase. Unused by the other kinds.')
param parentName string = ''

@description('Resource id of the Log Analytics workspace that receives the logs and metrics.')
param workspaceId string

@description('Diagnostic setting name (unique per target resource).')
param name string = 'to-log-analytics'

// Per kind: whether it emits resource logs, and the metric categories it exports.
var categories = {
  storageAccount: {
    logs: false
    metrics: [
      'Transaction'
    ]
  }
  blobService: {
    logs: true
    metrics: [
      'Transaction'
    ]
  }
  sqlDatabase: {
    logs: true
    metrics: [
      'Basic'
      'InstanceAndAppAdvanced'
      'WorkloadManagement'
    ]
  }
  keyVault: {
    logs: true
    metrics: [
      'AllMetrics'
    ]
  }
  networkSecurityGroup: {
    logs: true
    metrics: []
  }
  virtualNetwork: {
    logs: true
    metrics: [
      'AllMetrics'
    ]
  }
  azureFirewall: {
    logs: true
    metrics: [
      'AllMetrics'
    ]
  }
}

var properties = {
  workspaceId: workspaceId
  // The firewall's egress logs land in its resource-specific tables (AZFWNetworkRule, AZFWApplicationRule), not AzureDiagnostics.
  logAnalyticsDestinationType: resourceKind == 'azureFirewall' ? 'Dedicated' : null
  logs: categories[resourceKind].logs
    ? [
        {
          categoryGroup: 'allLogs'
          enabled: true
        }
      ]
    : []
  metrics: map(categories[resourceKind].metrics, category => {
    category: category
    enabled: true
  })
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = {
  name: resourceName
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' existing = {
  parent: storageAccount
  name: 'default'
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: parentName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01' existing = {
  parent: sqlServer
  name: resourceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = {
  name: resourceName
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2024-05-01' existing = {
  name: resourceName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: resourceName
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2024-05-01' existing = {
  name: resourceName
}

resource azureFirewallSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'azureFirewall') {
  scope: azureFirewall
  name: name
  properties: properties
}

resource storageAccountSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'storageAccount') {
  scope: storageAccount
  name: name
  properties: properties
}

resource blobServiceSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'blobService') {
  scope: blobService
  name: name
  properties: properties
}

resource sqlDatabaseSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'sqlDatabase') {
  scope: sqlDatabase
  name: name
  properties: properties
}

resource keyVaultSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'keyVault') {
  scope: keyVault
  name: name
  properties: properties
}

resource networkSecurityGroupSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'networkSecurityGroup') {
  scope: networkSecurityGroup
  name: name
  properties: properties
}

resource virtualNetworkSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (resourceKind == 'virtualNetwork') {
  scope: virtualNetwork
  name: name
  properties: properties
}
