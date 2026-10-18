@description('SQL logical server name (1-63 lowercase, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Display name of the Entra ID administrator (the group name when the administrator is a group).')
param entraAdminLogin string

@description('Object id of the Entra ID administrator.')
param entraAdminObjectId string

@description('Principal type of the Entra ID administrator.')
@allowed([
  'Group'
  'User'
  'Application'
])
param entraAdminPrincipalType string = 'Group'

@description('Entra tenant GUID of the administrator. Defaults to the deployment subscription tenant.')
param tenantId string = subscription().tenantId

@description('Allow Entra ID authentication only. Turn it off only to enable the break-glass SQL login.')
param entraOnlyAuthentication bool = true

@description('Break-glass SQL administrator login. Empty means no SQL login; required when entraOnlyAuthentication is false.')
param administratorLogin string = ''

@description('Break-glass SQL administrator password (supplied from a Key Vault reference).')
@secure()
param administratorLoginPassword string = ''

@description('Public network access. Disabled by default: the server is reached through a private endpoint.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Add the "allow Azure services" firewall rule. Takes effect only with public network access enabled.')
param allowAzureServices bool = false

@description('Resource tags.')
param tags object = {}

resource server 'Microsoft.Sql/servers@2023-08-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: empty(administratorLogin) ? null : administratorLogin
    administratorLoginPassword: empty(administratorLogin) ? null : administratorLoginPassword
    administrators: {
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: entraOnlyAuthentication
      login: entraAdminLogin
      sid: entraAdminObjectId
      principalType: entraAdminPrincipalType
      tenantId: tenantId
    }
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccess
  }
}

// The 0.0.0.0 rule is the special "Allow Azure services and resources to access this server" toggle.
resource allowAzure 'Microsoft.Sql/servers/firewallRules@2023-08-01' = if (allowAzureServices && publicNetworkAccess == 'Enabled') {
  parent: server
  name: 'AllowAllWindowsAzureIps'
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

output id string = server.id
output name string = server.name
output principalId string = server.identity.principalId
output fullyQualifiedDomainName string = server.properties.fullyQualifiedDomainName
