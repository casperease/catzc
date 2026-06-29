// Reusable bicep module: a Key Vault (RBAC-authorized, no access policies). Templates reference it
// with a relative `module` declaration (../../modules/key-vault.bicep) and `az bicep build` inlines
// it into the template's main.json.

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

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    tenantId: tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    enableRbacAuthorization: true
    accessPolicies: []
  }
}

output id string = vault.id
output name string = vault.name
