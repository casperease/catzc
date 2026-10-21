// ---
// catzc:
//   immutable:
//     with_body_sha: f0040b8660cb
// ---

// foundation, apex prod subscription (env psub, customer apex).
using '../../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'prod'
  owner: 'apex'
  'cost-center': 'apex'
  criticality: 'high'
  'data-classification': 'confidential'
}
param logAnalyticsName = 'psub-weu-zct-fnd-apex-log'
param keyVaultName = 'ps-weu-zct-fnd-ap-kv'
