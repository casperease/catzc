// ---
// catzc:
//   derived:
//     path: infrastructure/modules/subscription-diagnostic-setting.bicep
//     kind: template
//     subkind: module
//     language: bicep
//     filekind: bicep
//     track: infrastructure
//     relatives:
//       page: docs/references/infrastructure/modules/subscription-diagnostic-setting.bicep.md
// ---

targetScope = 'subscription'

@description('Resource id of the Log Analytics workspace that receives the activity log.')
param workspaceId string

@description('Diagnostic setting name (unique within the subscription).')
param name string = 'activity-log-to-log-analytics'

@description('Activity log categories to send.')
param categories array = [
  'Administrative'
  'Security'
  'ServiceHealth'
  'Alert'
  'Recommendation'
  'Policy'
  'Autoscale'
  'ResourceHealth'
]

resource setting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    workspaceId: workspaceId
    logs: [
      for category in categories: {
        category: category
        enabled: true
      }
    ]
  }
}

output id string = setting.id
output name string = setting.name
