@description('Kind of the resource the role is assigned on: this resource group itself, or one resource in it.')
@allowed([
  'resourceGroup'
  'storageAccount'
  'keyVault'
  'sqlServer'
  'workspace'
])
param resourceKind string

@description('Name of the resource the role is assigned on, in this resource group; unused for resourceGroup.')
param resourceName string = ''

@description('Object id of the Entra group or the managed identity\'s service principal that receives the role.')
param principalId string

@description('Group for an Entra group, ServicePrincipal for a managed identity; never a user.')
@allowed([
  'Group'
  'ServicePrincipal'
])
param principalType string = 'Group'

@description('Built-in role definition id, from roles.yml by config address; never a literal.')
param roleId string

@description('Attribute-based condition that narrows the assignment (version 2.0); empty assigns without one.')
param condition string = ''

@description('What the assignment is for, shown on the assignment.')
param assignmentDescription string = ''

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' existing = if (resourceKind == 'storageAccount') {
  name: resourceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (resourceKind == 'keyVault') {
  name: resourceName
}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01' existing = if (resourceKind == 'sqlServer') {
  name: resourceName
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = if (resourceKind == 'workspace') {
  name: resourceName
}

var roleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)

// The name is the same for the same scope, principal and role, so a redeploy updates the assignment instead of adding one.
var properties = {
  principalId: principalId
  principalType: principalType
  roleDefinitionId: roleDefinitionId
  description: empty(assignmentDescription) ? null : assignmentDescription
  condition: empty(condition) ? null : condition
  conditionVersion: empty(condition) ? null : '2.0'
}

resource resourceGroupAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceKind == 'resourceGroup') {
  name: guid(resourceGroup().id, principalId, roleId)
  properties: properties
}

resource storageAccountAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceKind == 'storageAccount') {
  scope: storageAccount
  name: guid(storageAccount.id, principalId, roleId)
  properties: properties
}

resource keyVaultAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceKind == 'keyVault') {
  scope: keyVault
  name: guid(keyVault.id, principalId, roleId)
  properties: properties
}

resource sqlServerAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceKind == 'sqlServer') {
  scope: sqlServer
  name: guid(sqlServer.id, principalId, roleId)
  properties: properties
}

resource workspaceAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (resourceKind == 'workspace') {
  scope: workspace
  name: guid(workspace.id, principalId, roleId)
  properties: properties
}
