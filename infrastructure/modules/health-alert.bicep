@description('Alert rule name (unique within the resource group).')
param name string

@description('What the alert watches: Azure Service Health (incidents, maintenance and advisories for the services the subscription uses) or Resource Health (a resource of the subscription becoming unavailable or degraded).')
@allowed([
  'ServiceHealth'
  'ResourceHealth'
])
param category string

@description('Resource id of the action group the alert notifies.')
param actionGroupId string

@description('Resource tags.')
param tags object = {}

// Activity log alerts are global resources that watch the whole subscription.
resource alert 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    enabled: true
    scopes: [
      subscription().id
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: category
        }
      ]
    }
    actions: {
      actionGroups: [
        {
          actionGroupId: actionGroupId
        }
      ]
    }
    description: category == 'ServiceHealth'
      ? 'An Azure service incident, planned maintenance or advisory affects this subscription.'
      : 'A resource of this subscription became unavailable or degraded.'
  }
}

output id string = alert.id
