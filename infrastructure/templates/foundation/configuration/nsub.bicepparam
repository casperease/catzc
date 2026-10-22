// foundation, shared nonprod subscription (env nsub). One config file ⟷ one resource group.
using '../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'nonprod'
  owner: 'platform'
  'cost-center': 'platform'
  criticality: 'high'
  'data-classification': 'internal'
}
param logAnalyticsName = 'nsub-weu-zct-fnd-log'
param keyVaultName = 'ns-weu-zct-fnd-kv'
