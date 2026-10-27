@description('Resource id of the SQL database the alerts watch.')
param databaseId string

@description('Name of the CPU alert rule (unique within the resource group).')
param cpuAlertName string

@description('Name of the deadlock alert rule (unique within the resource group).')
param deadlockAlertName string

@description('Name of the failed-connection alert rule (unique within the resource group).')
param failedConnectionAlertName string

@description('Average CPU percent, over the evaluation window, above which the CPU alert fires.')
@minValue(1)
@maxValue(100)
param cpuPercentThreshold int = 80

@description('Failed connections, summed over the evaluation window, above which the failed-connection alert fires.')
@minValue(1)
param failedConnectionThreshold int = 10

@description('Resource id of the action group every alert notifies.')
param actionGroupId string

@description('Resource tags.')
param tags object = {}

// Each alert evaluates every 5 minutes over a 15-minute window; one module call per alert, so each is its own named resource.
module cpuAlert 'metric-alert.bicep' = {
  name: 'alert-cpu'
  params: {
    name: cpuAlertName
    alertDescription: 'The production database runs above ${cpuPercentThreshold}% CPU.'
    severity: 2
    targetResourceId: databaseId
    metricName: 'cpu_percent'
    threshold: cpuPercentThreshold
    timeAggregation: 'Average'
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    actionGroupId: actionGroupId
    tags: tags
  }
}

module deadlockAlert 'metric-alert.bicep' = {
  name: 'alert-deadlock'
  params: {
    name: deadlockAlertName
    alertDescription: 'The production database reports a deadlock.'
    severity: 1
    targetResourceId: databaseId
    metricName: 'deadlock'
    threshold: 0
    timeAggregation: 'Total'
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    actionGroupId: actionGroupId
    tags: tags
  }
}

module failedConnectionAlert 'metric-alert.bicep' = {
  name: 'alert-failed-connection'
  params: {
    name: failedConnectionAlertName
    alertDescription: 'The production database refuses more than ${failedConnectionThreshold} connections.'
    severity: 2
    targetResourceId: databaseId
    metricName: 'connection_failed'
    threshold: failedConnectionThreshold
    timeAggregation: 'Total'
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    actionGroupId: actionGroupId
    tags: tags
  }
}

output alertIds array = [
  cpuAlert.outputs.id
  deadlockAlert.outputs.id
  failedConnectionAlert.outputs.id
]
