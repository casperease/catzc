// foundation, flux nonprod subscription (env nsub, customer flux). flux is dev-only -> nonprod only.
using '../../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'nonprod'
  owner: 'flux'
  'cost-center': 'flux'
  criticality: 'medium'
  'data-classification': 'confidential'
}
param logAnalyticsName = 'nsub-weu-zct-fnd-flux-log'
param keyVaultName = 'ns-weu-zct-fnd-fl-kv'
