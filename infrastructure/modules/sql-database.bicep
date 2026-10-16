// ---
// catzc:
//   immutable:
//     path: infrastructure/modules/sql-database.bicep
//     name: sql-database
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     tracktype: infrastructure
//     vendor: azure
//     module: sql-database
//     moduletype: bicep
//   edges:
//     page: docs/references/infrastructure/modules/sql-database.bicep.md
// ---

@description('Name of the existing SQL logical server that hosts this database.')
param serverName string

@description('Database name (unique within the server; e.g. mart / warehouse).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Database SKU name (Basic, S0, GP_Gen5, GP_S_Gen5, …).')
param skuName string = 'Basic'

@description('Database SKU tier (Basic, Standard, Premium, GeneralPurpose, BusinessCritical, Hyperscale).')
param tier string = 'Basic'

@description('vCore SKU family (Gen5). Empty for DTU SKUs.')
param skuFamily string = ''

@description('vCore count (or DTU capacity). 0 leaves it to the SKU default.')
param skuCapacity int = 0

@description('Spread the replicas across availability zones. Defaults on for the tiers that support it (Premium, GeneralPurpose, BusinessCritical, Hyperscale).')
param zoneRedundant bool = contains(
  [
    'Premium'
    'GeneralPurpose'
    'BusinessCritical'
    'Hyperscale'
  ],
  tier
)

@description('Backup storage redundancy.')
@allowed([
  'Geo'
  'GeoZone'
  'Zone'
  'Local'
])
param backupStorageRedundancy string = 'Geo'

@description('Point-in-time restore retention in days (Basic allows at most 7).')
@minValue(1)
@maxValue(35)
param backupRetentionDays int = 7

@description('Serverless only: minutes of inactivity before the database pauses; -1 disables auto-pause, 0 leaves it unset.')
param autoPauseDelay int = 0

@description('Serverless only: minimum vCores as a decimal string (e.g. \'0.5\'); empty leaves it unset.')
param minCapacity string = ''

@description('Resource tags.')
param tags object = {}

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2023-08-01' = {
  parent: server
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
    family: empty(skuFamily) ? null : skuFamily
    capacity: skuCapacity == 0 ? null : skuCapacity
  }
  properties: {
    zoneRedundant: zoneRedundant
    requestedBackupStorageRedundancy: backupStorageRedundancy
    autoPauseDelay: autoPauseDelay == 0 ? null : autoPauseDelay
    minCapacity: empty(minCapacity) ? null : json(minCapacity)
  }
}

resource shortTermRetention 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-08-01' = {
  parent: database
  name: 'default'
  properties: {
    retentionDays: backupRetentionDays
  }
}

output id string = database.id
output name string = database.name
