@description('Alert rule name (unique within the resource group).')
param name string

@description('Azure region of the rule: the region of the workspace it queries.')
param location string = resourceGroup().location

@description('Resource id of the Log Analytics workspace that holds the SQL audit log.')
param workspaceId string

@description('The SQL login whose every successful sign-in fires the alert: a break-glass login, whose use is always an event.')
param loginName string

@description('Resource id of the action group the alert notifies.')
param actionGroupId string

@description('Resource tags.')
param tags object = {}

// Every successful authentication of the login in the audit log, checked every five minutes over the last five.
var query = 'AzureDiagnostics | where Category == "SQLSecurityAuditEvents" and action_name_s == "DATABASE AUTHENTICATION SUCCEEDED" and server_principal_name_s == "${loginName}"'

resource rule 'Microsoft.Insights/scheduledQueryRules@2023-12-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    displayName: name
    description: 'The break-glass login ${loginName} signed in.'
    severity: 1
    enabled: true
    scopes: [
      workspaceId
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
    criteria: {
      allOf: [
        {
          query: query
          timeAggregation: 'Count'
          operator: 'GreaterThan'
          threshold: 0
          failingPeriods: {
            numberOfEvaluationPeriods: 1
            minFailingPeriodsToAlert: 1
          }
        }
      ]
    }
    actions: {
      actionGroups: [
        actionGroupId
      ]
    }
  }
}

output id string = rule.id
