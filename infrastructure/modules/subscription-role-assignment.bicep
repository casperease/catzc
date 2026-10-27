targetScope = 'subscription'

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

// A subscription-wide assignment needs a subscription-scoped file, as subscription-diagnostic-setting.bicep does for its setting.
resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, principalId, roleId)
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleId)
    description: empty(assignmentDescription) ? null : assignmentDescription
    condition: empty(condition) ? null : condition
    conditionVersion: empty(condition) ? null : '2.0'
  }
}
