// ---
// catzc:
//   immutable:
//     with_body_sha: "6df4d2df8981"
// ---

// foundation, nova nonprod subscription (env nsub, customer nova). nova is dev-only -> nonprod only.
using '../../main.bicep'

param tags = {
  workload: 'foundation'
  environment: 'nonprod'
  owner: 'nova'
  'cost-center': 'nova'
  criticality: 'medium'
  'data-classification': 'confidential'
}
param logAnalyticsName = 'nsub-weu-zct-fnd-nova-log'
param keyVaultName = 'ns-weu-zct-fnd-nv-kv'
