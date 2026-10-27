@description('Resource id of the SQL database the alerts watch.')
param databaseId string

@description('Name of the storage-capacity alert rule (unique within the resource group).')
param storageAlertName string

@description('Name of the compute-capacity alert rule (unique within the resource group).')
param computeAlertName string

@description('Percent of the maximum data size, at its peak over the evaluation window, above which the storage alert fires.')
@minValue(1)
@maxValue(100)
param storagePercentThreshold int = 85

@description('Percent of the provisioned or serverless vCore limit, on average over the evaluation window, above which the compute alert fires.')
@minValue(1)
@maxValue(100)
param computePercentThreshold int = 90

@description('Resource id of the action group every alert notifies.')
param actionGroupId string

@description('Resource tags.')
param tags object = {}

// A capacity alert warns before a limit is reached, so it looks at a longer window, hourly; one module call per alert.
module storageAlert 'metric-alert.bicep' = {
  name: 'alert-storage'
  params: {
    name: storageAlertName
    alertDescription: 'The production database has used more than ${storagePercentThreshold}% of its maximum data size.'
    severity: 2
    targetResourceId: databaseId
    metricName: 'storage_percent'
    threshold: storagePercentThreshold
    timeAggregation: 'Maximum'
    evaluationFrequency: 'PT1H'
    windowSize: 'PT6H'
    actionGroupId: actionGroupId
    tags: tags
  }
}

module computeAlert 'metric-alert.bicep' = {
  name: 'alert-compute'
  params: {
    name: computeAlertName
    alertDescription: 'The production database runs above ${computePercentThreshold}% of its vCore limit.'
    severity: 2
    targetResourceId: databaseId
    metricName: 'app_cpu_percent'
    threshold: computePercentThreshold
    timeAggregation: 'Average'
    evaluationFrequency: 'PT1H'
    windowSize: 'PT6H'
    actionGroupId: actionGroupId
    tags: tags
  }
}

output alertIds array = [
  storageAlert.outputs.id
  computeAlert.outputs.id
]
