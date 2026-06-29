// foundation — the once-per-subscription baseline: a Log Analytics workspace + a Key Vault. Deployed
// once per subscription (envs subn/subp), in the shared subscription and in each customer's. The Key
// Vault holds shared secrets for that subscription — notably the SQL admin password that consuming
// templates reference. Resources come from the reusable modules in infrastructure/modules/.

param location string = resourceGroup().location

param logAnalyticsName string
param keyVaultName string

module logAnalytics '../../modules/log-analytics.bicep' = {
  name: 'log-analytics'
  params: {
    name: logAnalyticsName
    location: location
  }
}

module keyVault '../../modules/key-vault.bicep' = {
  name: 'key-vault'
  params: {
    name: keyVaultName
    location: location
  }
}

output logAnalyticsId string = logAnalytics.outputs.id
output keyVaultId string = keyVault.outputs.id
output keyVaultName string = keyVault.outputs.name
