// foundation, shared prod subscription (env psub). One config file ⟷ one resource group.
using '../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'prod'
  owner: 'platform'
  'cost-center': 'platform'
  criticality: 'high'
  'data-classification': 'internal'
}
param logAnalyticsName = 'psub-weu-zct-fnd-log'
param keyVaultName = 'ps-weu-zct-fnd-kv'
