@description('Alert rule name (unique within the resource group).')
param name string

@description('What the alert says when it fires.')
param alertDescription string

@description('Severity, 0 (critical) to 4 (verbose).')
@minValue(0)
@maxValue(4)
param severity int

@description('Resource id of the resource the alert watches.')
param targetResourceId string

@description('The platform metric the alert reads.')
param metricName string

@description('The threshold the metric is compared with.')
param threshold int

@description('How the metric is aggregated over the window.')
@allowed([
  'Average'
  'Maximum'
  'Minimum'
  'Total'
])
param timeAggregation string

@description('How often the rule is evaluated, as an ISO 8601 duration.')
param evaluationFrequency string

@description('The window the metric is aggregated over, as an ISO 8601 duration.')
param windowSize string

@description('Resource id of the action group the alert notifies.')
param actionGroupId string

@description('Resource tags.')
param tags object = {}

// A metric alert is a global resource scoped to the one resource it watches; it fires when the aggregate exceeds the threshold.
resource alert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    description: alertDescription
    severity: severity
    enabled: true
    scopes: [
      targetResourceId
    ]
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: 'StaticThresholdCriterion'
          name: metricName
          metricName: metricName
          operator: 'GreaterThan'
          threshold: threshold
          timeAggregation: timeAggregation
        }
      ]
    }
    actions: [
      {
        actionGroupId: actionGroupId
      }
    ]
  }
}

output id string = alert.id
