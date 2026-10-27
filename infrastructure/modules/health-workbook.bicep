@description('The health workbook\'s display name, derived by the namer; Azure names the workbook by a GUID derived from it.')
param displayName string

param location string = resourceGroup().location

@description('The subscription\'s Log Analytics workspace, where the activity log streams; the history query runs there.')
param workspaceId string

@description('Resource tags.')
param tags object = {}

// The workload is this resource group: every query reads the health and the alerts of its resources only.
var workloadGroup = toLower(resourceGroup().name)

// The health model, declared once: the availability of each resource now, its history from the activity log, and the alerts its rules fired.
var healthQueries = [
  {
    title: 'Resource availability now'
    queryType: 1
    resourceType: 'microsoft.resourcegraph/resources'
    visualization: 'table'
    query: 'HealthResources | where type =~ "microsoft.resourcehealth/availabilitystatuses" | extend target = tolower(tostring(properties.targetResourceId)) | where target contains "/resourcegroups/${workloadGroup}/" | project target, availability = tostring(properties.availabilityState), reason = tostring(properties.reasonType), since = todatetime(properties.occurredTime)'
  }
  {
    title: 'Resource health events'
    queryType: 0
    resourceType: 'microsoft.operationalinsights/workspaces'
    visualization: 'timechart'
    query: 'AzureActivity | where CategoryValue == "ResourceHealth" and tolower(ResourceGroup) == "${workloadGroup}" | summarize events = count() by Resource = tostring(split(_ResourceId, "/")[-1]), bin(TimeGenerated, 1h)'
  }
  {
    title: 'Alerts fired by the workload\'s rules'
    queryType: 1
    resourceType: 'microsoft.resourcegraph/resources'
    visualization: 'table'
    query: 'AlertsManagementResources | where type =~ "microsoft.alertsmanagement/alerts" | where tolower(tostring(properties.essentials.targetResourceGroup)) == "${workloadGroup}" | project alert = name, severity = tostring(properties.essentials.severity), condition = tostring(properties.essentials.monitorCondition), fired = todatetime(properties.essentials.startDateTime)'
  }
]

// A Resource Graph item reads the subscription; a workspace item reads the workbook's source workspace.
var healthWorkbookItems = [
  for (query, index) in healthQueries: {
    type: 3
    name: 'health-${index}'
    content: {
      version: 'KqlItem/1.0'
      title: query.title
      query: query.query
      queryType: query.queryType
      resourceType: query.resourceType
      crossComponentResources: query.queryType == 1 ? [subscription().id] : [workspaceId]
      visualization: query.visualization
    }
  }
]

module workbook 'workbook.bicep' = {
  name: 'health-workbook'
  params: {
    displayName: displayName
    location: location
    workspaceId: workspaceId
    serializedData: string({
      version: 'Notebook/1.0'
      items: healthWorkbookItems
    })
    tags: tags
  }
}

output id string = workbook.outputs.id
