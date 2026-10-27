@description('Action group name (unique within the resource group).')
param name string

@description('Short name shown in the notifications it sends (at most 12 characters).')
@maxLength(12)
param shortName string

@description('Azure built-in roles whose members the group notifies by email, by role definition id from roles.yml; never a literal.')
param roleIds array

@description('Resource tags.')
param tags object = {}

// An action group is a global resource; its receivers are the role's members at the time an alert fires, so no address is kept here.
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: name
  location: 'global'
  tags: tags
  properties: {
    groupShortName: shortName
    enabled: true
    armRoleReceivers: [
      for roleId in roleIds: {
        name: 'role-${roleId}'
        roleId: roleId
        useCommonAlertSchema: true
      }
    ]
  }
}

output id string = actionGroup.id
output name string = actionGroup.name
