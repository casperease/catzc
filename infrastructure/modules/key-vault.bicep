// ---
// catzc:
//   immutable:
//     with_body_sha: "37cd9a57541f"
//   edges:
//     docs: "[key-vault.bicep.md](../../docs/references/infrastructure/modules/key-vault.bicep.md)"
// ---

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

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
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
    accessPolicies: []
  }
}

output id string = vault.id
output name string = vault.name
