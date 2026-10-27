targetScope = 'subscription'

@description('Alert name (letters, digits and hyphens; unique within the subscription).')
param name string

@description('Display name of the alert.')
param displayName string = name

@description('Email addresses that receive the anomaly alert; Cost Management delivers an anomaly alert by email only.')
@minLength(1)
param recipients array

@description('First day of the alert schedule, yyyy-MM-dd.')
param startDate string

@description('Last day of the alert schedule, yyyy-MM-dd; an alert runs at most a year at a time.')
param endDate string

// A daily anomaly alert over the subscription's cost, from Cost Management's built-in anomaly view.
resource alert 'Microsoft.CostManagement/scheduledActions@2023-11-01' = {
  name: name
  kind: 'InsightAlert'
  properties: {
    displayName: displayName
    status: 'Enabled'
    viewId: '${subscription().id}/providers/Microsoft.CostManagement/views/ms:DailyAnomalyByResourceGroup'
    notification: {
      to: recipients
      subject: 'Cost anomaly in ${subscription().displayName}'
    }
    schedule: {
      frequency: 'Daily'
      startDate: startDate
      endDate: endDate
    }
  }
}

output id string = alert.id
output name string = alert.name
