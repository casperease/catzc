@description('Key vault name (3-24 alphanumeric/hyphen, starts with a letter, globally unique).')
param name string

@description('Azure region. Defaults to the enclosing resource group location.')
param location string = resourceGroup().location

@description('Entra tenant GUID that owns the vault. Defaults to the deployment subscription tenant.')
param tenantId string = subscription().tenantId

@description('Vault SKU.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Resource tags (a landing zone that requires a tag denies an untagged vault).')
param tags object = {}

@description('Let Azure Resource Manager read secrets during a deployment: a parameter file\'s Key Vault reference (expedition\'s break-glass SQL password) resolves only when this is on.')
param enabledForTemplateDeployment bool = true

@description('Public network access: off by default, so the vault is reached only through its private endpoint.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Days a deleted secret stays recoverable (7-90).')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

resource vault 'Microsoft.KeyVault/vaults@2024-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    enableRbacAuthorization: true
    enabledForTemplateDeployment: enabledForTemplateDeployment
    // Purge protection cannot be turned off again once on, so it is no parameter: no deployment can make a vault purgeable.
    enablePurgeProtection: true
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    publicNetworkAccess: publicNetworkAccess
    // A closed vault network: only its private endpoint and the trusted Azure services (Resource Manager reading a Key Vault reference).
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
    accessPolicies: []
  }
}

output id string = vault.id
output name string = vault.name
