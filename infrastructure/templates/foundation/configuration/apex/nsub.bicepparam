// foundation, apex nonprod subscription (env nsub, customer apex).
using '../../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'nonprod'
  owner: 'apex'
  'cost-center': 'apex'
  criticality: 'medium'
  'data-classification': 'confidential'
}
param logAnalyticsName = 'nsub-weu-zct-fnd-apex-log'
param keyVaultName = 'ns-weu-zct-fnd-ap-kv'
