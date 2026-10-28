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

  @description('The Microsoft cloud security benchmark assignment, in audit mode.')
  benchmark: string

  @description('The allowed-resource-types assignment.')
  resourceTypes: string
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

@description('The resource types the landing zone allows: the types the shared modules declare, a fact the build derives (options.yml facts).')
param allowedResourceTypes array

@description('Budget name.')
param budgetName string

@description('Budget amount per month, in the billing currency of the subscription.')
@minValue(1)
param budgetAmount int

@description('First day of the budget, yyyy-MM-dd, the first of a month.')
param budgetStartDate string

@description('Budget alert thresholds on actual cost, in percent of the amount.')
param budgetThresholds array = [
  50
  80
  100
]

@description('Budget alert thresholds on forecasted cost, in percent of the amount.')
param budgetForecastThresholds array = [
  100
]

@description('Name of the subscription\'s daily cost export; derived by the namer.')
param costExportName string

@description('Name of the subscription\'s cost anomaly alert; derived by the namer.')
param anomalyAlertName string

@description('Comma-separated email addresses that receive the cost anomaly alert: a Key Vault reference to foundation\'s vault, seeded at deploy time, so no address is in config.')
@secure()
param anomalyAlertRecipients string

@description('Defender for Cloud plans turned on for the services the landing zone runs.')
param defenderPlans array = [
  'StorageAccounts'
  'SqlServers'
  'KeyVaults'
  'Arm'
]

@description('The built-in roles, roles.yml by config address (options.yml addresses): every role id the template assigns.')
param roles object

@description('The Entra group object ids of the slot\'s owner in its subscription\'s class (options.yml facts); an empty id assigns nothing.')
param groups object

// The cost export runs from the budget's first day for five years, the longest schedule kept between renewals.
var costExportEndDate = dateTimeAdd('${budgetStartDate}T00:00:00Z', 'P5Y', 'yyyy-MM-dd')

// The anomaly alert runs from the budget's first day for a year, the longest schedule Cost Management takes.
var anomalyAlertEndDate = dateTimeAdd('${budgetStartDate}T00:00:00Z', 'P1Y', 'yyyy-MM-dd')

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

// The monitoring of the landing zone: health alerts, the activity log, the network diagnostics and the network's flow log.
module monitoring '../../modules/landing-zone-monitoring.bicep' = {
  name: 'monitoring'
  params: {
    location: location
    tags: tags
    resourceGroupName: resourceGroupName
    logAnalyticsResourceGroupName: logAnalyticsResourceGroupName
    logAnalyticsName: logAnalyticsName
    actionGroupName: actionGroupName
    healthAlertNames: healthAlertNames
    flowLogStorageAccountName: flowLogStorageAccountName
    networkWatcherResourceGroupName: networkWatcherResourceGroupName
    virtualNetworkName: landingZoneNetwork.outputs.virtualNetworkName
    virtualNetworkId: landingZoneNetwork.outputs.virtualNetworkId
    networkSecurityGroupSubnetNames: networkSecurityGroupSubnetNames
    networkSecurityGroupResourceNames: landingZoneNetwork.outputs.networkSecurityGroupResourceNames
  }
}

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
    allowedResourceTypes: allowedResourceTypes
  }
}

module budget '../../modules/budget.bicep' = {
  name: 'budget'
  params: {
    name: budgetName
    amount: budgetAmount
    startDate: budgetStartDate
    thresholds: budgetThresholds
    forecastThresholds: budgetForecastThresholds
  }
}

// The subscription's daily cost, exported to foundation's governed storage, in its own container with its own retention.
module costExport '../../modules/cost-export.bicep' = if (!empty(flowLogStorageAccountName)) {
  name: 'cost-export'
  params: {
    name: costExportName
    storageAccountId: resourceId(
      subscription().subscriptionId,
      logAnalyticsResourceGroupName,
      'Microsoft.Storage/storageAccounts',
      flowLogStorageAccountName
    )
    startDate: budgetStartDate
    endDate: costExportEndDate
  }
}

// A daily anomaly alert over the subscription's cost, emailed to the recipients the deploy reads from foundation's vault.
module anomalyAlert '../../modules/scheduled-action.bicep' = {
  name: 'anomaly-alert'
  params: {
    name: anomalyAlertName
    recipients: map(split(anomalyAlertRecipients, ','), recipient => trim(recipient))
    startDate: budgetStartDate
    endDate: anomalyAlertEndDate
  }
}

module defender '../../modules/defender-plans.bicep' = {
  name: 'defender-plans'
  params: {
    plans: defenderPlans
  }
}

module subscriptionRoles '../../modules/subscription-role-assignment.bicep' = [
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
module workspaceReaders '../../modules/role-assignment.bicep' = if (!empty(groups.readers)) {
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

output resourceGroupName string = networkResourceGroup.outputs.name
output virtualNetworkId string = landingZoneNetwork.outputs.virtualNetworkId
output subnetIds object = landingZoneNetwork.outputs.subnetIds
output privateDnsZoneIds array = landingZoneNetwork.outputs.privateDnsZoneIds
