@description('Azure region. Defaults to the resource group location; it must match the region of the network.')
param location string = resourceGroup().location

@description('The CAF tags, set on every resource.')
param tags object

@description('Storage account name (3-24 lowercase alphanumeric, globally unique).')
param storageAccountName string

@description('Storage SKU per environment class: Standard_ZRS for production, Standard_LRS for a non-production environment.')
param storageSkuName string

@description('The default access tier of new blobs.')
param storageAccessTier string

@description('Days since last modification before a blob moves to the cool tier; 0 turns the move off.')
param storageCoolAfterDays int

@description('Days since last modification before a blob moves to the archive tier; 0 turns the move off.')
param storageArchiveAfterDays int

@description('SQL logical server name (globally unique).')
param sqlServerName string

@description('SQL database name.')
param sqlDatabaseName string

@description('Private endpoint name of the blob service.')
param blobPrivateEndpointName string

@description('Private endpoint name of the SQL server.')
param sqlPrivateEndpointName string

@description('Display name of the Entra ID administrator group of the SQL server.')
param entraAdminLogin string

@description('Object id of the Entra ID administrator group of the SQL server.')
param entraAdminObjectId string

@description('Break-glass SQL administrator login.')
param administratorLogin string

@description('Break-glass SQL administrator password: a Key Vault reference to foundation\'s vault.')
@secure()
param administratorLoginPassword string

@description('Database SKU name: GP_S_Gen5 (serverless) or GP_Gen5 (provisioned); closed, so a build rejects any other SKU.')
@allowed([
  'GP_S_Gen5'
  'GP_Gen5'
])
param databaseSkuName string

@description('Database SKU tier.')
@allowed([
  'Basic'
  'Standard'
  'Premium'
  'GeneralPurpose'
  'BusinessCritical'
  'Hyperscale'
])
param databaseTier string

@description('vCore SKU family. Empty for DTU SKUs.')
param databaseSkuFamily string = ''

@description('vCore count (the maximum for serverless). 0 leaves it to the SKU default.')
@minValue(0)
param databaseSkuCapacity int = 0

@description('Spread the database replicas across availability zones. On by default; a nonprod config turns it off.')
param databaseZoneRedundant bool = true

@description('Backup storage redundancy of the database.')
@allowed([
  'Geo'
  'GeoZone'
  'Zone'
  'Local'
])
param databaseBackupStorageRedundancy string

@description('Point-in-time restore retention of the database, in days.')
@minValue(1)
@maxValue(35)
param databaseBackupRetentionDays int

@description('Serverless only: minutes of inactivity before the database pauses. 0 leaves it unset (provisioned).')
param databaseAutoPauseDelay int = 0

@description('Serverless only: minimum vCores as a decimal string (e.g. \'0.5\'). Empty leaves it unset (provisioned).')
param databaseMinCapacity string = ''

@description('Resource group of the discovery network the private endpoints land in.')
param networkResourceGroupName string

@description('Name of the discovery virtual network.')
param virtualNetworkName string

@description('Subnet of the private endpoints.')
param privateEndpointSubnetName string = 'private-endpoints'

@description('Subscription id of the hub that holds the private DNS zones, by config address.')
param privateDnsZoneSubscriptionId string

@description('Resource group of the hub that holds the private DNS zones.')
param privateDnsZoneResourceGroupName string

@description('Resource group of foundation\'s Log Analytics workspace.')
param logAnalyticsResourceGroupName string

@description('Name of foundation\'s Log Analytics workspace.')
param logAnalyticsName string

@description('Name of foundation\'s action group, in the workspace\'s resource group: the break-glass login alert notifies it.')
param actionGroupName string

@description('Name of the break-glass login alert; derived by the namer.')
param breakGlassLoginAlertName string

@description('Whether the slot is production, from its environment in azure.yml: only production carries the database alerts.')
param deployProductionAlerts bool

@description('Names of the database metric alerts (cpu, deadlock, failedConnection); derived by the namer.')
param databaseMetricAlertNames object

@description('Names of the database capacity alerts (storage, compute); derived by the namer.')
param databaseCapacityAlertNames object

var actionGroupId = resourceId(
  subscription().subscriptionId,
  logAnalyticsResourceGroupName,
  'Microsoft.Insights/actionGroups',
  actionGroupName
)

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
  scope: resourceGroup(networkResourceGroupName)
}

resource privateEndpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' existing = {
  parent: virtualNetwork
  name: privateEndpointSubnetName
}

resource blobDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  scope: resourceGroup(privateDnsZoneSubscriptionId, privateDnsZoneResourceGroupName)
}

resource sqlDnsZone 'Microsoft.Network/privateDnsZones@2024-06-01' existing = {
  name: 'privatelink${environment().suffixes.sqlServerHostname}'
  scope: resourceGroup(privateDnsZoneSubscriptionId, privateDnsZoneResourceGroupName)
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsResourceGroupName)
}

module storage '../../modules/storage-account.bicep' = {
  name: 'storage-account'
  params: {
    name: storageAccountName
    location: location
    tags: tags
    skuName: storageSkuName
    accessTier: storageAccessTier
    coolAfterDays: storageCoolAfterDays
    archiveAfterDays: storageArchiveAfterDays
  }
}

module sqlServer '../../modules/sql-server.bicep' = {
  name: 'sql-server'
  params: {
    name: sqlServerName
    location: location
    entraAdminLogin: entraAdminLogin
    entraAdminObjectId: entraAdminObjectId
    entraOnlyAuthentication: false
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    tags: tags
  }
}

module sqlDatabase '../../modules/sql-database.bicep' = {
  name: 'sql-database'
  params: {
    serverName: sqlServer.outputs.name
    name: sqlDatabaseName
    location: location
    skuName: databaseSkuName
    tier: databaseTier
    skuFamily: databaseSkuFamily
    skuCapacity: databaseSkuCapacity
    zoneRedundant: databaseZoneRedundant
    backupStorageRedundancy: databaseBackupStorageRedundancy
    backupRetentionDays: databaseBackupRetentionDays
    autoPauseDelay: databaseAutoPauseDelay
    minCapacity: databaseMinCapacity
    tags: tags
  }
}

module blobPrivateEndpoint '../../modules/private-endpoint.bicep' = {
  name: 'private-endpoint-blob'
  params: {
    name: blobPrivateEndpointName
    location: location
    subnetId: privateEndpointSubnet.id
    privateLinkServiceId: storage.outputs.id
    groupId: 'blob'
    privateDnsZoneIds: [
      blobDnsZone.id
    ]
    tags: tags
  }
}

module sqlPrivateEndpoint '../../modules/private-endpoint.bicep' = {
  name: 'private-endpoint-sql'
  params: {
    name: sqlPrivateEndpointName
    location: location
    subnetId: privateEndpointSubnet.id
    privateLinkServiceId: sqlServer.outputs.id
    groupId: 'sqlServer'
    privateDnsZoneIds: [
      sqlDnsZone.id
    ]
    tags: tags
  }
}

module storageDiagnostics '../../modules/diagnostic-setting.bicep' = {
  name: 'diagnostics-storage-account'
  params: {
    resourceKind: 'storageAccount'
    resourceName: storage.outputs.name
    workspaceId: workspace.id
  }
}

module blobDiagnostics '../../modules/diagnostic-setting.bicep' = {
  name: 'diagnostics-blob-service'
  params: {
    resourceKind: 'blobService'
    resourceName: storage.outputs.name
    workspaceId: workspace.id
  }
}

module sqlDatabaseDiagnostics '../../modules/diagnostic-setting.bicep' = {
  name: 'diagnostics-sql-database'
  params: {
    resourceKind: 'sqlDatabase'
    resourceName: sqlDatabase.outputs.name
    parentName: sqlServer.outputs.name
    workspaceId: workspace.id
  }
}

// The server's logins and statements are audited into the workspace, so the use of the break-glass login is on record.
module sqlAudit '../../modules/sql-audit.bicep' = {
  name: 'sql-audit'
  params: {
    serverName: sqlServer.outputs.name
    workspaceId: workspace.id
  }
}

// Any sign-in of the break-glass login pages the subscription's Owner role: its use is always an event.
module breakGlassLoginAlert '../../modules/login-alert.bicep' = if (!empty(administratorLogin)) {
  name: 'break-glass-login-alert'
  dependsOn: [
    sqlAudit
  ]
  params: {
    name: breakGlassLoginAlertName
    location: workspace.location
    workspaceId: workspace.id
    loginName: administratorLogin
    actionGroupId: actionGroupId
    tags: tags
  }
}

// The production database's metric and capacity alerts notify the subscription's action group; no other environment carries them.
module databaseMetricAlerts '../../modules/sql-database-metric-alerts.bicep' = if (deployProductionAlerts) {
  name: 'database-metric-alerts'
  params: {
    databaseId: sqlDatabase.outputs.id
    cpuAlertName: databaseMetricAlertNames.cpu
    deadlockAlertName: databaseMetricAlertNames.deadlock
    failedConnectionAlertName: databaseMetricAlertNames.failedConnection
    actionGroupId: actionGroupId
    tags: tags
  }
}

module databaseCapacityAlerts '../../modules/sql-database-capacity-alerts.bicep' = if (deployProductionAlerts) {
  name: 'database-capacity-alerts'
  params: {
    databaseId: sqlDatabase.outputs.id
    storageAlertName: databaseCapacityAlertNames.storage
    computeAlertName: databaseCapacityAlertNames.compute
    actionGroupId: actionGroupId
    tags: tags
  }
}

output storageAccountId string = storage.outputs.id
output sqlServerId string = sqlServer.outputs.id
output sqlServerFullyQualifiedDomainName string = sqlServer.outputs.fullyQualifiedDomainName
output sqlDatabaseId string = sqlDatabase.outputs.id
