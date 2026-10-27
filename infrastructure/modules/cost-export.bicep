targetScope = 'subscription'

@description('Export name (letters, digits, hyphens and underscores; unique within the subscription).')
param name string

@description('Resource id of the storage account the export writes to.')
param storageAccountId string

@description('Blob container the export writes to; it must exist in the storage account.')
param container string = 'cost-exports'

@description('Folder under the container the export writes to.')
param rootFolderPath string = subscription().subscriptionId

@description('First day of the export schedule, yyyy-MM-dd.')
param startDate string

@description('Last day of the export schedule, yyyy-MM-dd.')
param endDate string

// A daily month-to-date export of the subscription's actual cost, as CSV, to the subscription's governed storage.
resource export 'Microsoft.CostManagement/exports@2023-11-01' = {
  name: name
  properties: {
    format: 'Csv'
    schedule: {
      status: 'Active'
      recurrence: 'Daily'
      recurrencePeriod: {
        from: startDate
        to: endDate
      }
    }
    deliveryInfo: {
      destination: {
        resourceId: storageAccountId
        container: container
        rootFolderPath: rootFolderPath
      }
    }
    definition: {
      type: 'ActualCost'
      timeframe: 'MonthToDate'
      dataSet: {
        granularity: 'Daily'
      }
    }
  }
}

output id string = export.id
output name string = export.name
