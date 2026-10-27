@description('Flow log name (unique within its Network Watcher).')
param name string

@description('Azure region of the Network Watcher and the flow log: the region of the network they watch.')
param location string = resourceGroup().location

@description('Network Watcher name. Azure names the one watcher per region and subscription NetworkWatcher_<region>, in NetworkWatcherRG; declaring it under that name is idempotent beside the one Azure creates itself.')
param networkWatcherName string = 'NetworkWatcher_${location}'

@description('Resource id of the virtual network the flow log records.')
param targetResourceId string

@description('Resource id of the storage account the flow log writes to.')
param storageAccountId string

@description('Days the flow log files are kept in the storage account (0 keeps them forever).')
@minValue(0)
@maxValue(365)
param retentionDays int = 30

@description('Resource id of the Log Analytics workspace that Traffic Analytics writes to.')
param workspaceResourceId string

@description('Region of the Log Analytics workspace.')
param workspaceRegion string

@description('Workspace (customer) id of the Log Analytics workspace, a GUID.')
param workspaceCustomerId string

@description('Minutes between the Traffic Analytics processing runs: 10 or 60.')
@allowed([
  10
  60
])
param trafficAnalyticsIntervalInMinutes int = 60

@description('Resource tags.')
param tags object = {}

resource networkWatcher 'Microsoft.Network/networkWatchers@2024-05-01' = {
  name: networkWatcherName
  location: location
  tags: tags
  properties: {}
}

resource flowLog 'Microsoft.Network/networkWatchers/flowLogs@2024-05-01' = {
  parent: networkWatcher
  name: name
  location: location
  tags: tags
  properties: {
    targetResourceId: targetResourceId
    storageId: storageAccountId
    enabled: true
    format: {
      type: 'JSON'
      version: 2
    }
    retentionPolicy: {
      enabled: retentionDays > 0
      days: retentionDays
    }
    flowAnalyticsConfiguration: {
      networkWatcherFlowAnalyticsConfiguration: {
        enabled: true
        workspaceResourceId: workspaceResourceId
        workspaceRegion: workspaceRegion
        workspaceId: workspaceCustomerId
        trafficAnalyticsInterval: trafficAnalyticsIntervalInMinutes
      }
    }
  }
}

output id string = flowLog.id
output name string = flowLog.name
