// ---
// catzc:
//   derived:
//     path: infrastructure/templates/discovery/main.bicep
//     kind: bicep-template
//     language: bicep
//     track: infrastructure
//     relatives:
//       page: docs/references/infrastructure/templates/discovery/main.bicep.md
// ---

targetScope = 'subscription'

@description('A virtual network on the far side of a peering, in its own subscription.')
type remoteNetwork = {
  @description('The azure.yml subscription that holds the network.')
  subscription: string

  @description('Resource group of the network.')
  resourceGroupName: string

  @description('Name of the network.')
  virtualNetworkName: string

  @description('Name of the local peering towards the network.')
  peeringName: string
}

@description('Names of the three policy assignments.')
type policyAssignmentNameSet = {
  @description('The allowed-locations assignment.')
  allowedLocations: string

  @description('The require-a-tag-on-resources assignment.')
  requireTag: string

  @description('The no-public-IP-on-network-interfaces assignment.')
  noPublicIp: string
}

@description('Azure region of the resource group and its resources. Defaults to the deployment location.')
param location string = deployment().location

@description('The CAF tags, set on the resource group and on every resource that takes tags.')
param tags object

@description('The azure.yml subscriptions, by config address: resolves the subscription id of a peered network.')
param subscriptions object

@description('Kind of the network of this subscription, from network.yml: a hub (shared) or a spoke (customer).')
@allowed([
  'hub'
  'spoke'
])
param networkKind string

@description('Address space of the virtual network, from network.yml.')
param vnetAddressSpace string

@description('The subnets of the virtual network, name to CIDR, from network.yml.')
param subnetPrefixes object

@description('Resource group that holds the network.')
param resourceGroupName string

@description('Name of the virtual network.')
param virtualNetworkName string

@description('Network security group name per subnet; a subnet absent here gets none.')
param networkSecurityGroupNames object

@description('Name of the route table attached to every spoke subnet. Unused by a hub.')
param routeTableName string = ''

@description('Spoke only: the hub network this spoke peers to.')
param hub remoteNetwork?

@description('Hub only: the spoke networks this hub peers to and links its private DNS zones to.')
param spokes remoteNetwork[] = []

@description('Resource group of foundation\'s Log Analytics workspace.')
param logAnalyticsResourceGroupName string

@description('Name of foundation\'s Log Analytics workspace.')
param logAnalyticsName string

@description('Enforcement mode of the policy assignments, from azure.yml policy_enforcement by config address.')
@allowed([
  'Default'
  'DoNotEnforce'
])
param policyEnforcementMode string

@description('Names of the policy assignments.')
param policyAssignmentNames policyAssignmentNameSet

@description('The tag every resource must carry; the CAF tags include it.')
param requiredTagName string = 'cost-center'

@description('Budget name.')
param budgetName string

@description('Budget amount per month, in the billing currency of the subscription.')
@minValue(1)
param budgetAmount int

@description('First day of the budget, yyyy-MM-dd, the first of a month.')
param budgetStartDate string

@description('Budget alert thresholds, in percent of the amount.')
param budgetThresholds array = [
  50
  80
  100
]

var isHub = networkKind == 'hub'
var subnetNames = objectKeys(subnetPrefixes)
var networkSecurityGroupSubnetNames = filter(subnetNames, subnetName => contains(networkSecurityGroupNames, subnetName))

// Built-in policy definitions (tenant-level ids, fixed by Azure).
var policyDefinitions = {
  allowedLocations: {
    id: 'e56962a6-4747-49cd-b67b-bf8b01975c4c'
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
    id: '871b6d14-10aa-478d-b590-94f262ecfa99'
    parameters: {
      tagName: {
        value: requiredTagName
      }
    }
    message: 'Every resource in this landing zone carries the ${requiredTagName} tag.'
  }
  noPublicIp: {
    id: '83a86a26-fd1f-447c-b59d-e51f44264114'
    parameters: {}
    message: 'Network interfaces in this landing zone have no public IP address.'
  }
}

// The private DNS zones of the private-link services the workloads use (SQL Database and Blob Storage).
var privateDnsZoneNames = [
  'privatelink${environment().suffixes.sqlServerHostname}'
  'privatelink.blob.${environment().suffixes.storage}'
]

var securityRules = [
  {
    name: 'allow-virtual-network-inbound'
    properties: {
      priority: 100
      direction: 'Inbound'
      access: 'Allow'
      protocol: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      sourcePortRange: '*'
      destinationAddressPrefix: 'VirtualNetwork'
      destinationPortRange: '*'
    }
  }
  {
    name: 'deny-internet-inbound'
    properties: {
      priority: 4000
      direction: 'Inbound'
      access: 'Deny'
      protocol: '*'
      sourceAddressPrefix: 'Internet'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '*'
    }
  }
]

var hubNetworkId = isHub
  ? ''
  : resourceId(
      subscriptions[hub!.subscription].id,
      hub!.resourceGroupName,
      'Microsoft.Network/virtualNetworks',
      hub!.virtualNetworkName
    )

var spokeNetworkIds = [
  for spoke in spokes: resourceId(
    subscriptions[spoke.subscription].id,
    spoke.resourceGroupName,
    'Microsoft.Network/virtualNetworks',
    spoke.virtualNetworkName
  )
]

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsName
  scope: resourceGroup(logAnalyticsResourceGroupName)
}

module networkResourceGroup '../../modules/resource-group.bicep' = {
  name: 'resource-group'
  params: {
    name: resourceGroupName
    location: location
    tags: tags
  }
}

module networkSecurityGroups '../../modules/nsg.bicep' = [
  for subnetName in networkSecurityGroupSubnetNames: {
    name: 'nsg-${subnetName}'
    scope: resourceGroup(resourceGroupName)
    dependsOn: [
      networkResourceGroup
    ]
    params: {
      name: networkSecurityGroupNames[subnetName]
      location: location
      securityRules: securityRules
      tags: tags
    }
  }
]

module routeTable '../../modules/route-table.bicep' = if (!isHub) {
  name: 'route-table'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    networkResourceGroup
  ]
  params: {
    name: routeTableName
    location: location
    tags: tags
  }
}

module virtualNetwork '../../modules/virtual-network.bicep' = {
  name: 'virtual-network'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    networkResourceGroup
    networkSecurityGroups
    routeTable
  ]
  params: {
    name: virtualNetworkName
    location: location
    addressPrefix: vnetAddressSpace
    subnets: [
      for subnetName in subnetNames: {
        name: subnetName
        addressPrefix: subnetPrefixes[subnetName]
        networkSecurityGroupId: contains(networkSecurityGroupNames, subnetName)
          ? resourceId(
              subscription().subscriptionId,
              resourceGroupName,
              'Microsoft.Network/networkSecurityGroups',
              networkSecurityGroupNames[subnetName]
            )
          : null
        routeTableId: isHub
          ? null
          : resourceId(
              subscription().subscriptionId,
              resourceGroupName,
              'Microsoft.Network/routeTables',
              routeTableName
            )
      }
    ]
    tags: tags
  }
}

module hubPeering '../../modules/vnet-peering.bicep' = if (!isHub) {
  name: 'peering-hub'
  scope: resourceGroup(resourceGroupName)
  params: {
    virtualNetworkName: virtualNetwork.outputs.name
    name: hub.?peeringName ?? ''
    remoteVirtualNetworkId: hubNetworkId
  }
}

module spokePeerings '../../modules/vnet-peering.bicep' = [
  for (spoke, index) in (isHub ? spokes : []): {
    name: 'peering-${spoke.subscription}'
    scope: resourceGroup(resourceGroupName)
    params: {
      virtualNetworkName: virtualNetwork.outputs.name
      name: spoke.peeringName
      remoteVirtualNetworkId: spokeNetworkIds[index]
    }
  }
]

module privateDnsZones '../../modules/private-dns-zone.bicep' = [
  for zoneName in (isHub ? privateDnsZoneNames : []): {
    name: 'dns-${zoneName}'
    scope: resourceGroup(resourceGroupName)
    params: {
      name: zoneName
      virtualNetworkIds: concat(
        [
          virtualNetwork.outputs.id
        ],
        spokeNetworkIds
      )
      tags: tags
    }
  }
]

module activityLog '../../modules/subscription-diagnostic-setting.bicep' = {
  name: 'activity-log'
  params: {
    workspaceId: workspace.id
  }
}

module virtualNetworkDiagnostics '../../modules/diagnostic-setting.bicep' = {
  name: 'diagnostics-virtual-network'
  scope: resourceGroup(resourceGroupName)
  params: {
    resourceKind: 'virtualNetwork'
    resourceName: virtualNetwork.outputs.name
    workspaceId: workspace.id
  }
}

module networkSecurityGroupDiagnostics '../../modules/diagnostic-setting.bicep' = [
  for (subnetName, index) in networkSecurityGroupSubnetNames: {
    name: 'diagnostics-nsg-${subnetName}'
    scope: resourceGroup(resourceGroupName)
    params: {
      resourceKind: 'networkSecurityGroup'
      resourceName: networkSecurityGroups[index].outputs.name
      workspaceId: workspace.id
    }
  }
]

module policyAssignments '../../modules/policy-assignment.bicep' = [
  for policy in items(policyDefinitions): {
    name: 'policy-${policy.key}'
    params: {
      name: policyAssignmentNames[policy.key]
      policyDefinitionId: tenantResourceId('Microsoft.Authorization/policyDefinitions', policy.value.id)
      parameters: policy.value.parameters
      enforcementMode: policyEnforcementMode
      nonComplianceMessage: policy.value.message
    }
  }
]

module budget '../../modules/budget.bicep' = {
  name: 'budget'
  params: {
    name: budgetName
    amount: budgetAmount
    startDate: budgetStartDate
    thresholds: budgetThresholds
  }
}

output resourceGroupName string = networkResourceGroup.outputs.name
output virtualNetworkId string = virtualNetwork.outputs.id
output subnetIds object = virtualNetwork.outputs.subnetIds
output privateDnsZoneIds array = [
  for (zoneName, index) in (isHub ? privateDnsZoneNames : []): privateDnsZones[index].outputs.id
]
