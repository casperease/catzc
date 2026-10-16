// ---
// catzc:
//   immutable:
//     repo_status: clean
//     path: infrastructure/modules/budget.bicep
//     name: budget
//     filetype: bicep
//     kind: template
//     subkind: module
//     language: bicep
//     track: infrastructure
//     tracktype: infrastructure
//     vendor: azure
//     module: budget
//     moduletype: bicep
//   edges:
//     page: docs/references/infrastructure/modules/budget.bicep.md
// ---

targetScope = 'subscription'

@description('Budget name (1-63 characters: letters, digits, underscores, and hyphens; unique within the subscription).')
param name string

@description('Budget amount, in the billing currency of the subscription.')
@minValue(1)
param amount int

@description('The period the amount covers; it resets at the start of each period.')
@allowed([
  'Monthly'
  'Quarterly'
  'Annually'
])
param timeGrain string = 'Monthly'

@description('First day of the budget, yyyy-MM-dd; it must be the first of a month.')
param startDate string

@description('Alert thresholds, in percent of the amount.')
param thresholds array = [
  50
  80
  100
]

@description('Compare the thresholds against actual or forecasted cost.')
@allowed([
  'Actual'
  'Forecasted'
])
param thresholdType string = 'Actual'

@description('Subscription roles whose holders receive the alerts.')
param contactRoles array = [
  'Owner'
]

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: name
  properties: {
    category: 'Cost'
    amount: amount
    timeGrain: timeGrain
    timePeriod: {
      startDate: startDate
    }
    notifications: toObject(
      thresholds,
      threshold => '${toLower(thresholdType)}-greater-than-${threshold}',
      threshold => {
        enabled: true
        operator: 'GreaterThan'
        threshold: threshold
        thresholdType: thresholdType
        contactEmails: []
        contactRoles: contactRoles
      }
    )
  }
}

output id string = budget.id
output name string = budget.name
