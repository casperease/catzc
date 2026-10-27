@description('The workbook\'s display name, derived by the namer; Azure names a workbook by a GUID, which derives from it.')
param displayName string

param location string = resourceGroup().location

@description('The Log Analytics workspace the workbook reads; its queries run there.')
param workspaceId string

@description('The workbook\'s content: the serialized workbook JSON (version Notebook/1.0).')
param serializedData string

@description('Resource tags.')
param tags object = {}

resource workbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(workspaceId, displayName)
  location: location
  tags: tags
  kind: 'shared'
  properties: {
    displayName: displayName
    category: 'workbook'
    serializedData: serializedData
    sourceId: workspaceId
  }
}

output id string = workbook.id
