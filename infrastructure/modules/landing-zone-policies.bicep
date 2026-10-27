targetScope = 'subscription'

@description('Azure region the allowed-locations policy admits.')
param location string

@description('Enforcement mode of the policy assignments, from azure.yml policy_enforcement by config address.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param policyEnforcementMode string

@description('Name of each policy assignment, keyed like the policy definitions below.')
param policyAssignmentNames object

@description('The CAF tags every resource must carry: the keys of the azure.yml tag schema.')
param requiredTagNames array

@description('The storage SKUs the landing zone allows.')
param allowedStorageSkus array

@description('The virtual machine sizes the landing zone allows.')
param allowedVmSizes array

resource cafTagsDefinition 'Microsoft.Authorization/policyDefinitions@2025-01-01' = {
  name: guid(subscription().id, 'require-caf-tags')
  properties: {
    displayName: 'Require the CAF tags on resources'
    policyType: 'Custom'
    mode: 'Indexed'
    policyRule: {
      if: {
        anyOf: [
          for tagName in requiredTagNames: {
            field: 'tags[${tagName}]'
            exists: 'false'
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

// The policy definitions assigned: the built-ins by their tenant-level ids (fixed by Azure), the CAF-tags one by its subscription id.
var policyDefinitions = {
  allowedLocations: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'e56962a6-4747-49cd-b67b-bf8b01975c4c')
    parameters: {
      listOfAllowedLocations: {
        value: [
          location
        ]
      }
    }
    message: 'Resources in this landing zone deploy to its region only.'
  }
  requireTag: {
    id: cafTagsDefinition.id
    parameters: {}
    message: 'Every resource in this landing zone carries the CAF tags ${join(requiredTagNames, ', ')}.'
  }
  noPublicIp: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', '83a86a26-fd1f-447c-b59d-e51f44264114')
    parameters: {}
    message: 'Network interfaces in this landing zone have no public IP address.'
  }
  storageNoPublicAccess: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'b2982f36-99f2-4db5-8eff-283140c09693')
    parameters: {
      effect: {
        value: 'Deny'
      }
    }
    message: 'Storage accounts in this landing zone have public network access off.'
  }
  sqlNoPublicAccess: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', '1b8ca024-1d5c-4dec-8995-b1a932b41780')
    parameters: {
      effect: {
        value: 'Deny'
      }
    }
    message: 'SQL servers in this landing zone have public network access off.'
  }
  dataDiagnostics: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', '7f89b1eb-583c-429a-8828-af049802c1d9')
    parameters: {
      listOfResourceTypes: {
        value: dataResourceTypes
      }
    }
    message: 'Every data resource in this landing zone has a diagnostic setting.'
  }
  storageSkus: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', '7433c107-6db4-4ad1-b57a-a76dce0154a1')
    parameters: {
      listOfAllowedSKUs: {
        value: allowedStorageSkus
      }
    }
    message: 'Storage accounts in this landing zone use a listed SKU only.'
  }
  vmSkus: {
    id: tenantResourceId('Microsoft.Authorization/policyDefinitions', 'cccc23c7-8427-4f53-ad12-b6a63eb452b3')
    parameters: {
      listOfAllowedSKUs: {
        value: allowedVmSizes
      }
    }
    message: 'Virtual machines in this landing zone use a listed size only.'
  }
  // The Microsoft cloud security benchmark initiative, assigned to audit only: it reports, and never denies.
  benchmark: {
    id: tenantResourceId('Microsoft.Authorization/policySetDefinitions', '1f3afdf9-d0c9-4c3d-847f-89da613e70a8')
    parameters: {}
    message: 'Resources in this landing zone are measured against the Microsoft cloud security benchmark.'
    enforcementMode: 'DoNotEnforce'
  }
}

// The data resource kinds the diagnostic-setting audit covers.
var dataResourceTypes = [
  'Microsoft.Storage/storageAccounts'
  'Microsoft.Sql/servers/databases'
  'Microsoft.KeyVault/vaults'
  'Microsoft.DataFactory/factories'
]

module policyAssignments 'policy-assignment.bicep' = [
  for policy in items(policyDefinitions): {
    name: 'policy-${policy.key}'
    params: {
      name: policyAssignmentNames[policy.key]
      policyDefinitionId: policy.value.id
      parameters: policy.value.parameters
      enforcementMode: policy.value.?enforcementMode ?? policyEnforcementMode
      nonComplianceMessage: policy.value.message
    }
  }
]
