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

@description('Names of the six policy assignments.')
type policyAssignmentNameSet = {
  @description('The allowed-locations assignment.')
  allowedLocations: string

  @description('The require-a-tag-on-resources assignment.')
  requireTag: string

  @description('The no-public-IP-on-network-interfaces assignment.')
  noPublicIp: string

  @description('The storage-accounts-disable-public-network-access assignment.')
  storageNoPublicAccess: string

  @description('The SQL-Database-public-network-access-disabled assignment.')
  sqlNoPublicAccess: string

  @description('The diagnostic-setting-on-data-resources audit assignment.')
  dataDiagnostics: string

  @description('The allowed-storage-account-SKUs assignment.')
  storageSkus: string

  @description('The allowed-virtual-machine-size-SKUs assignment.')
  vmSkus: string
}

@description('Azure region of the resource group and its resources. Defaults to the deployment location.')
param location string = deployment().location

@description('The CAF tags, set on the resource group and on every resource that takes tags.')
param tags object

@description('The azure.yml subscriptions, by config address: resolves the subscription id of a peered network.')
param subscriptions object

@description('The network of this subscription, its network.yml record by config address: kind, address space, subnets and a hub\'s firewall.')
param network object

@description('Every subscription\'s network.yml record, by config address: the hub\'s firewall address for a spoke, the spokes\' address spaces for a hub.')
param networks object

@description('Whether this subscription holds a production environment (options.yml facts); a production hub spreads its firewall over the zones.')
param productionSubscription bool

@description('Hub only: names of the firewall, its policy and its two public IPs; every slot receives its derived names.')
param firewallName string
param firewallPolicyName string
param firewallPublicIpName string
param firewallManagementPublicIpName string

@description('The egress every hub firewall allows, network.yml firewall_egress by config address.')
param firewallEgress object

@description('The inbound flows the security groups allow, by subnet role: network.yml nsg_flows by config address.')
param nsgFlows array

@description('Resource group that holds the network.')
param resourceGroupName string

@description('Name of the virtual network.')
param virtualNetworkName string

@description('Network security group name per subnet; a subnet absent here gets none.')
param networkSecurityGroupNames object

@description('Name of the route table attached to every spoke subnet. Unused by a hub, which still receives its derived name.')
param routeTableName string = ''

@description('Spoke only: the hub network this spoke peers to.')
param hub remoteNetwork?

@description('Hub only: the spoke networks this hub peers to and links its private DNS zones to.')
param spokes remoteNetwork[] = []

@description('Resource group of foundation\'s Log Analytics workspace.')
param logAnalyticsResourceGroupName string

@description('Name of foundation\'s Log Analytics workspace.')
param logAnalyticsName string

@description('Name of foundation\'s flow-log storage account, in the workspace\'s resource group; derived by the PrePost hook, empty deploys no flow log.')
param flowLogStorageAccountName string = ''

@description('Name of foundation\'s action group, in the workspace\'s resource group: the health alerts notify it.')
param actionGroupName string

@description('Name of each health alert, keyed by its category (ServiceHealth, ResourceHealth); derived by the namer.')
param healthAlertNames object

@description('The resource group Azure keeps its Network Watchers in; the flow log of the network lives under the region\'s watcher there.')
param networkWatcherResourceGroupName string = 'NetworkWatcherRG'

@description('Enforcement mode of the policy assignments: a fact the build derives from the subscription the slot targets (options.yml facts).')
@allowed([
  'Default'
  'DoNotEnforce'
])
param policyEnforcementMode string

@description('Names of the policy assignments.')
param policyAssignmentNames policyAssignmentNameSet

@description('The CAF tags every resource must carry: the keys of the azure.yml tag schema.')
param requiredTagNames array = [
  'workload'
  'environment'
  'owner'
  'cost-center'
  'criticality'
  'data-classification'
]

@description('The storage SKUs the landing zone allows: zone-redundant for production, locally redundant for the rest.')
param allowedStorageSkus array = [
  'Standard_LRS'
  'Standard_ZRS'
]

@description('The virtual machine sizes the landing zone allows: the burstable size vm.bicep defaults to.')
param allowedVmSizes array = [
  'Standard_B1s'
]

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

var isHub = network.kind == 'hub'
var subnetNames = objectKeys(network.subnets)
var networkSecurityGroupSubnetNames = filter(subnetNames, subnetName => contains(networkSecurityGroupNames, subnetName))

// The private DNS zones of the private-link services the workloads use (SQL Database, Blob Storage and Key Vault).
var privateDnsZoneNames = [
  'privatelink${environment().suffixes.sqlServerHostname}'
  'privatelink.blob.${environment().suffixes.storage}'
  'privatelink${replace(environment().suffixes.keyvaultDns, '.vault.', '.vaultcore.')}'
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

resource workspace 'Microsoft.OperationalInsights/workspaces@2025-02-01' existing = {
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

// The network of the landing zone: security groups, route table, virtual network, peerings, the hub's private DNS zones and their locks.
module landingZoneNetwork '../../modules/landing-zone-network.bicep' = {
  name: 'network'
  scope: resourceGroup(resourceGroupName)
  dependsOn: [
    networkResourceGroup
  ]
  params: {
    location: location
    tags: tags
    networkKind: network.kind
    vnetAddressSpace: network.vnet_address_space
    subnetPrefixes: network.subnets
    virtualNetworkName: virtualNetworkName
    networkSecurityGroupNames: networkSecurityGroupNames
    routeTableName: routeTableName
    hubPeeringName: hub.?peeringName ?? ''
    hubNetworkId: hubNetworkId
    spokes: spokes
    spokeNetworkIds: spokeNetworkIds
    privateDnsZoneNames: privateDnsZoneNames
    firewallPrivateIp: isHub ? network.firewall_private_ip : networks[hub!.subscription].firewall_private_ip
    firewallSku: isHub ? network.firewall_sku : ''
    spokeAddressSpaces: [for spoke in spokes: networks[spoke.subscription].vnet_address_space]
    firewallEgress: firewallEgress
    firewallName: firewallName
    firewallPolicyName: firewallPolicyName
    firewallPublicIpName: firewallPublicIpName
    firewallManagementPublicIpName: firewallManagementPublicIpName
    firewallZones: productionSubscription ? ['1', '2', '3'] : []
    workspaceId: workspace.id
    nsgFlows: nsgFlows
    hubSharedServicesPrefix: isHub ? '' : networks[hub!.subscription].subnets['shared-services']
  }
}

// Service Health and Resource Health of the subscription notify foundation's action group, so they reach the subscription's Owner role.
module healthAlerts '../../modules/health-alert.bicep' = [
  for category in [
    'ServiceHealth'
    'ResourceHealth'
  ]: {
    name: 'alert-${toLower(category)}'
    scope: resourceGroup(resourceGroupName)
    dependsOn: [
      networkResourceGroup
    ]
    params: {
      name: healthAlertNames[category]
      category: category
      actionGroupId: resourceId(
        subscription().subscriptionId,
        logAnalyticsResourceGroupName,
        'Microsoft.Insights/actionGroups',
        actionGroupName
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
    resourceName: landingZoneNetwork.outputs.virtualNetworkName
    workspaceId: workspace.id
  }
}

module networkWatcherResourceGroup '../../modules/resource-group.bicep' = if (!empty(flowLogStorageAccountName)) {
  name: 'network-watcher-resource-group'
  params: {
    name: networkWatcherResourceGroupName
    location: location
    tags: tags
  }
}

// The network's flow log, to foundation's flow-log storage, with Traffic Analytics into the workspace.
module flowLog '../../modules/flow-log.bicep' = if (!empty(flowLogStorageAccountName)) {
  name: 'flow-log'
  scope: resourceGroup(networkWatcherResourceGroupName)
  dependsOn: [
    networkWatcherResourceGroup
  ]
  params: {
    name: '${virtualNetworkName}-flow-log'
    location: location
    targetResourceId: landingZoneNetwork.outputs.virtualNetworkId
    storageAccountId: resourceId(
      subscription().subscriptionId,
      logAnalyticsResourceGroupName,
      'Microsoft.Storage/storageAccounts',
      flowLogStorageAccountName
    )
    workspaceResourceId: workspace.id
    workspaceRegion: workspace.location
    workspaceCustomerId: workspace.properties.customerId
    tags: tags
  }
}

module networkSecurityGroupDiagnostics '../../modules/diagnostic-setting.bicep' = [
  for (subnetName, index) in networkSecurityGroupSubnetNames: {
    name: 'diagnostics-nsg-${subnetName}'
    scope: resourceGroup(resourceGroupName)
    params: {
      resourceKind: 'networkSecurityGroup'
      resourceName: landingZoneNetwork.outputs.networkSecurityGroupResourceNames[index]
      workspaceId: workspace.id
    }
  }
]

// The CAF-tags definition and the policy assignments of the landing zone.
module policies '../../modules/landing-zone-policies.bicep' = {
  name: 'policies'
  params: {
    location: location
    policyEnforcementMode: policyEnforcementMode
    policyAssignmentNames: policyAssignmentNames
    requiredTagNames: requiredTagNames
    allowedStorageSkus: allowedStorageSkus
    allowedVmSizes: allowedVmSizes
  }
}

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
output virtualNetworkId string = landingZoneNetwork.outputs.virtualNetworkId
output subnetIds object = landingZoneNetwork.outputs.subnetIds
output privateDnsZoneIds array = landingZoneNetwork.outputs.privateDnsZoneIds
