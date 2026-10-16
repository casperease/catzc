// ---
// catzc:
//   derived:
//     path: infrastructure/modules/policy-assignment.bicep
//     kind: bicep-module
//     language: bicep
//     track: infrastructure
//     relatives:
//       page: docs/references/infrastructure/modules/policy-assignment.bicep.md
// ---

targetScope = 'subscription'

@description('Assignment name (1-64 characters, unique within the subscription; no < > * % & : \\ ? . + / and not ending in a space).')
param name string

@description('Display name shown in the portal (up to 128 characters). Defaults to the name.')
param displayName string = name

@description('Assignment description.')
param assignmentDescription string = ''

@description('Resource id of the policy definition (or initiative), e.g. /providers/Microsoft.Authorization/policyDefinitions/<guid>.')
param policyDefinitionId string

@description('Policy parameters, in the ARM shape: { <name>: { value: <value> } }.')
param parameters object = {}

@description('Default enforces the policy effect; DoNotEnforce evaluates compliance without enforcing it.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param enforcementMode string

@description('Message shown when a resource is non-compliant. Empty sets none.')
param nonComplianceMessage string = ''

@description('Give the assignment a system-assigned managed identity (needed by deployIfNotExists and modify effects).')
param assignIdentity bool = false

@description('Region of the managed identity. Defaults to the deployment location.')
param location string = deployment().location

@description('Role definition ids (GUIDs) granted to the managed identity on the subscription, for remediation.')
param roleDefinitionIds array = []

resource assignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
  name: name
  location: assignIdentity ? location : null
  identity: assignIdentity
    ? {
        type: 'SystemAssigned'
      }
    : null
  properties: {
    displayName: displayName
    description: empty(assignmentDescription) ? null : assignmentDescription
    policyDefinitionId: policyDefinitionId
    parameters: parameters
    enforcementMode: enforcementMode
    nonComplianceMessages: empty(nonComplianceMessage)
      ? []
      : [
          {
            message: nonComplianceMessage
          }
        ]
  }
}

resource remediationRoles 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for roleDefinitionId in (assignIdentity ? roleDefinitionIds : []): {
    name: guid(subscription().id, name, roleDefinitionId)
    properties: {
      roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionId)
      principalId: assignment.identity.principalId
      principalType: 'ServicePrincipal'
    }
  }
]

output id string = assignment.id
output name string = assignment.name
output principalId string = assignIdentity ? assignment.identity.principalId : ''
