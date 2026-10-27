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

@description('Alert thresholds on actual cost, in percent of the amount.')
param thresholds array = [
  50
  80
  100
]

@description('Alert thresholds on forecasted cost, in percent of the amount; none by default.')
param forecastThresholds array = []

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
    // One notification per threshold of each type, keyed by its type and percent, so an actual and a forecast alert never collide.
    notifications: toObject(
      concat(
        map(thresholds, threshold => { threshold: threshold, thresholdType: 'Actual' }),
        map(forecastThresholds, threshold => { threshold: threshold, thresholdType: 'Forecasted' })
      ),
      entry => '${toLower(entry.thresholdType)}-greater-than-${entry.threshold}',
      entry => {
        enabled: true
        operator: 'GreaterThan'
        threshold: entry.threshold
        thresholdType: entry.thresholdType
        contactEmails: []
        contactRoles: contactRoles
      }
    )
  }
}

output id string = budget.id
output name string = budget.name
