// Reusable bicep module: a SQL logical server (SQL authentication) with the "allow Azure services"
// firewall rule. Databases are separate (../../modules/sql-database.bicep). Templates reference it with
// a relative `module` declaration; `az bicep build` inlines it.

@description('SQL logical server name (3-63 lowercase, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('SQL administrator login name.')
param administratorLogin string

@description('SQL administrator password.')
@secure()
param administratorLoginPassword string

resource server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

// Allow other Azure services to reach the server. The 0.0.0.0 rule is the
// special "Allow Azure services and resources to access this server" toggle.
resource allowAzure 'Microsoft.Sql/servers/firewallRules@2023-08-01-preview' = {
  parent: server
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output id string = server.id
output name string = server.name
output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName
