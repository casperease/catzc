// Reusable bicep module: a single SQL database on an existing logical server. Templates reference it
// with a relative `module` declaration (../../modules/sql-database.bicep); `az bicep build` inlines it.

@description('Name of the existing SQL logical server that hosts this database.')
param serverName string

@description('Database name (server-scoped; e.g. mart / warehouse).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Database SKU name. Basic is the cheapest fixed tier.')
param skuName string = 'Basic'

@description('Database SKU tier.')
param tier string = 'Basic'

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: server
  name: name
  location: location
  sku: {
    name: skuName
    tier: tier
  }
}

output id string = database.id
output name string = database.name
