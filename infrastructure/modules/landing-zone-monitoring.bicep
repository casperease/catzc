targetScope = 'subscription'

@description('Azure region of the network resources the flow log watches.')
param location string

@description('The CAF tags, set on every resource that takes tags.')
param tags object

@description('Resource group that holds the network.')
param resourceGroupName string

@description('Resource group of foundation\'s Log Analytics workspace, its action group and its flow-log storage account.')
param logAnalyticsResourceGroupName string

@description('Name of foundation\'s Log Analytics workspace.')
param logAnalyticsName string

@description('Name of foundation\'s action group, in the workspace\'s resource group: the health alerts notify it.')
param actionGroupName string

@description('Name of each health alert, keyed by its category (ServiceHealth, ResourceHealth).')
param healthAlertNames object

@description('Name of foundation\'s flow-log storage account, in the workspace\'s resource group; empty deploys no flow log.')
param flowLogStorageAccountName string

@description('The resource group Azure keeps its Network Watchers in; the flow log of the network lives under the region\'s watcher there.')
param networkWatcherResourceGroupName string

@description('Name of the virtual network.')
param virtualNetworkName string

@description('Resource id of the virtual network.')
param virtualNetworkId string

@description('The subnets that have a network security group, in the order of the group names below.')
param networkSecurityGroupSubnetNames array

@description('The resource name of each subnet\'s network security group.')
param networkSecurityGroupResourceNames array

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsResourceGroupName)
}

// Service Health and Resource Health of the subscription notify foundation's action group, so they reach the subscription's Owner role.
module healthAlerts 'health-alert.bicep' = [
  for category in [
    'ServiceHealth'
    'ResourceHealth'
  ]: {
    name: 'alert-${toLower(category)}'
    scope: resourceGroup(resourceGroupName)
    params: {
      name: healthAlertNames[category]
      category: category
      actionGroupId: resourceId(
        subscription().subscriptionId,
        logAnalyticsResourceGroupName,
        'Microsoft.Insights/actionGroups',
        actionGroupName
      )
      tags: tags
    }
  }
]

module activityLog 'subscription-diagnostic-setting.bicep' = {
  name: 'activity-log'
  params: {
    workspaceId: workspace.id
  }
}

module virtualNetworkDiagnostics 'diagnostic-setting.bicep' = {
  name: 'diagnostics-virtual-network'
  scope: resourceGroup(resourceGroupName)
  params: {
    resourceKind: 'virtualNetwork'
    resourceName: virtualNetworkName
    workspaceId: workspace.id
  }
}

module networkWatcherResourceGroup 'resource-group.bicep' = if (!empty(flowLogStorageAccountName)) {
  name: 'network-watcher-resource-group'
  params: {
    name: networkWatcherResourceGroupName
    location: location
    tags: tags
  }
}

// The network's flow log, to foundation's flow-log storage, with Traffic Analytics into the workspace.
module flowLog 'flow-log.bicep' = if (!empty(flowLogStorageAccountName)) {
  name: 'flow-log'
  scope: resourceGroup(networkWatcherResourceGroupName)
  dependsOn: [
    networkWatcherResourceGroup
  ]
  params: {
    name: '${virtualNetworkName}-flow-log'
    location: location
    targetResourceId: virtualNetworkId
    storageAccountId: resourceId(
      subscription().subscriptionId,
      logAnalyticsResourceGroupName,
      'Microsoft.Storage/storageAccounts',
      flowLogStorageAccountName
    )
    workspaceResourceId: workspace.id
    workspaceRegion: workspace.location
    workspaceCustomerId: workspace.properties.customerId
    tags: tags
  }
}

module networkSecurityGroupDiagnostics 'diagnostic-setting.bicep' = [
  for (subnetName, index) in networkSecurityGroupSubnetNames: {
    name: 'diagnostics-nsg-${subnetName}'
    scope: resourceGroup(resourceGroupName)
    params: {
      resourceKind: 'networkSecurityGroup'
      resourceName: networkSecurityGroupResourceNames[index]
      workspaceId: workspace.id
    }
  }
]
