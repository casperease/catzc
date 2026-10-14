// Reusable bicep module: a policy assignment at subscription scope. The caller passes the policy
// definition id, its parameters, and the enforcement mode, which has no default here: the template
// reads it from the repository-wide setting in azure.yml (`policy_enforcement`). A policy whose effect
// deploys or modifies resources (deployIfNotExists, modify) needs a managed identity and the roles its
// remediation uses: set `assignIdentity` and list the role definition ids, and the module grants them on
// the subscription. `az bicep build` inlines it.

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
