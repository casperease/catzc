targetScope = 'subscription'

@description('The built-in roles, roles.yml by config address: every role id the module assigns.')
param roles object

@description('The Entra group object ids of the landing zone\'s readers and operators; an empty id assigns nothing.')
param groups object

@description('Resource group of foundation\'s Log Analytics workspace.')
param logAnalyticsResourceGroupName string

@description('Name of foundation\'s Log Analytics workspace.')
param logAnalyticsName string

// The roles the operators may grant: the data roles, never a privileged one.
var dataRoleIds = join(
  [
    roles.storage_blob_data_reader.id
    roles.storage_blob_data_contributor.id
    roles.key_vault_secrets_user.id
  ],
  ', '
)

// The operators' role administration, conditioned so that a role assignment they write or delete holds a data role only.
var dataRoleCondition = '((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/write\'})) OR (@Request[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${dataRoleIds}})) AND ((!(ActionMatches{\'Microsoft.Authorization/roleAssignments/delete\'})) OR (@Resource[Microsoft.Authorization/roleAssignments:RoleDefinitionId] ForAnyOfAnyValues:GuidEquals {${dataRoleIds}}))'

// The standard subscription assignments, declared once: readers read, operators manage and grant the data roles.
var subscriptionAssignments = [
  {
    purpose: 'readers-reader'
    principalId: groups.readers
    roleId: roles.reader.id
    condition: ''
  }
  {
    purpose: 'operators-contributor'
    principalId: groups.operators
    roleId: roles.contributor.id
    condition: ''
  }
  {
    purpose: 'operators-rbac-administrator'
    principalId: groups.operators
    roleId: roles.rbac_administrator.id
    condition: dataRoleCondition
  }
]

module subscriptionRoles 'subscription-role-assignment.bicep' = [
  for assignment in subscriptionAssignments: if (!empty(assignment.principalId)) {
    name: 'role-${assignment.purpose}'
    params: {
      principalId: assignment.principalId
      roleId: assignment.roleId
      condition: assignment.condition
      assignmentDescription: assignment.purpose
    }
  }
]

// The readers read the workspace's data too, on foundation's workspace in its own resource group.
module workspaceReaders 'role-assignment.bicep' = if (!empty(groups.readers)) {
  name: 'role-readers-log-analytics-reader'
  scope: resourceGroup(logAnalyticsResourceGroupName)
  params: {
    resourceKind: 'workspace'
    resourceName: logAnalyticsName
    principalId: groups.readers
    roleId: roles.log_analytics_reader.id
    assignmentDescription: 'readers-log-analytics-reader'
  }
}
