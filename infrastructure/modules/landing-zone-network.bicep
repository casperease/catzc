@description('Azure region of the network resources.')
param location string

@description('The CAF tags, set on every resource that takes tags.')
param tags object

@description('Kind of the network: a hub (shared) or a spoke (customer).')
@allowed([
  'hub'
  'spoke'
])
param networkKind string

@description('Address space of the virtual network.')
param vnetAddressSpace string

@description('The subnets of the virtual network, name to CIDR.')
param subnetPrefixes object

@description('Name of the virtual network.')
param virtualNetworkName string

@description('Network security group name per subnet; a subnet absent here gets none.')
param networkSecurityGroupNames object

@description('Name of the route table: on every spoke subnet, and on a hub\'s shared-services subnet.')
param routeTableName string

@description('Spoke only: the name of the peering towards the hub.')
param hubPeeringName string

@description('Spoke only: the network id of the hub.')
param hubNetworkId string

@description('Hub only: the spokes it peers to, each with its subscription and peering name, in the order of spokeNetworkIds.')
param spokes array

@description('Hub only: the spoke network ids it peers to and links its private DNS zones to.')
param spokeNetworkIds array

@description('The private DNS zones a hub holds and locks.')
param privateDnsZoneNames array

@description('The hub firewall\'s private address: a hub\'s own, a spoke\'s hub\'s (network.yml firewall_private_ip).')
param firewallPrivateIp string

@description('Hub only: the firewall tier, Basic or Standard (network.yml firewall_sku).')
param firewallSku string

@description('Hub only: the address spaces of its spokes, routed through the firewall and allowed its egress.')
param spokeAddressSpaces array

@description('Hub only: the service tags and FQDN tags the firewall lets the spokes reach (network.yml firewall_egress).')
param firewallEgress object

@description('Hub only: names of the firewall, its policy and its two public IPs.')
param firewallName string
param firewallPolicyName string
param firewallPublicIpName string
param firewallManagementPublicIpName string

@description('Hub only: availability zones of the firewall and its addresses; empty for none.')
param firewallZones array

@description('Resource id of the Log Analytics workspace that receives the firewall\'s egress logs.')
param workspaceId string

@description('The inbound flows the security groups allow, by subnet role (network.yml nsg_flows).')
param nsgFlows array

@description('Spoke only: the hub\'s shared-services range, the source of the management flow; empty on a hub.')
param hubSharedServicesPrefix string

var isHub = networkKind == 'hub'
var subnetNames = objectKeys(subnetPrefixes)
var networkSecurityGroupSubnetNames = filter(subnetNames, subnetName => contains(networkSecurityGroupNames, subnetName))

// A subnet's role names it in the flows: a spoke's private-endpoints, a hub's shared-services, every other one a workload subnet.
var subnetRoles = toObject(
  subnetNames,
  subnetName => subnetName,
  subnetName => contains(['private-endpoints', 'shared-services'], subnetName) ? subnetName : 'workload'
)
var workloadPrefixes = map(filter(subnetNames, subnetName => subnetRoles[subnetName] == 'workload'), subnetName => subnetPrefixes[subnetName])

// Each subnet allows the declared flows to its role, and nothing else from the network or the internet.
var flowRules = toObject(
  networkSecurityGroupSubnetNames,
  subnetName => subnetName,
  subnetName =>
    map(
      filter(
        nsgFlows,
        flow =>
          flow.to == subnetRoles[subnetName] && (flow.from != 'shared-services' || !empty(hubSharedServicesPrefix)) && (flow.from != 'workload' || !empty(workloadPrefixes))
      ),
      (flow, index) => {
        name: flow.name
        properties: {
          priority: 100 + index * 10
          direction: 'Inbound'
          access: 'Allow'
          protocol: flow.protocol
          sourceAddressPrefixes: flow.from == 'same-subnet'
            ? [subnetPrefixes[subnetName]]
            : (flow.from == 'workload' ? workloadPrefixes : [hubSharedServicesPrefix])
          sourcePortRange: '*'
          destinationAddressPrefix: subnetPrefixes[subnetName]
          destinationPortRanges: flow.ports
        }
      }
    )
)

var denyRules = [
  {
    name: 'deny-virtual-network-inbound'
    properties: {
      priority: 4000
      direction: 'Inbound'
      access: 'Deny'
      protocol: '*'
      sourceAddressPrefix: 'VirtualNetwork'
      sourcePortRange: '*'
      destinationAddressPrefix: '*'
      destinationPortRange: '*'
    }
  }
  {
    name: 'deny-internet-inbound'
    properties: {
      priority: 4010
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

module networkSecurityGroups 'nsg.bicep' = [
  for subnetName in networkSecurityGroupSubnetNames: {
    name: 'nsg-${subnetName}'
    params: {
      name: networkSecurityGroupNames[subnetName]
      location: location
      securityRules: concat(flowRules[subnetName], denyRules)
      tags: tags
    }
  }
]

var hubRoutes = [
  for (addressSpace, index) in spokeAddressSpaces: {
    name: 'spoke-${index}'
    properties: {
      addressPrefix: addressSpace
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: firewallPrivateIp
    }
  }
]
var spokeRoutes = [
  {
    name: 'egress-through-hub-firewall'
    properties: {
      addressPrefix: '0.0.0.0/0'
      nextHopType: 'VirtualAppliance'
      nextHopIpAddress: firewallPrivateIp
    }
  }
]
var routes = isHub ? hubRoutes : spokeRoutes

// The firewall and gateway subnets take no route table: a default route there would break them.
var routedSubnetNames = isHub ? ['shared-services'] : subnetNames

module routeTable 'route-table.bicep' = {
  name: 'route-table'
  params: {
    name: routeTableName
    location: location
    routes: routes
    disableBgpRoutePropagation: !isHub
    tags: tags
  }
}

module firewallPolicy 'firewall-policy.bicep' = if (isHub) {
  name: 'firewall-policy'
  params: {
    name: firewallPolicyName
    location: location
    sku: firewallSku
    sourceAddresses: spokeAddressSpaces
    serviceTags: firewallEgress.service_tags
    fqdnTags: firewallEgress.fqdn_tags
    tags: tags
  }
}

module firewall 'firewall.bicep' = if (isHub) {
  name: 'firewall'
  params: {
    name: firewallName
    location: location
    sku: firewallSku
    firewallPolicyId: firewallPolicy!.outputs.id
    virtualNetworkName: virtualNetwork.outputs.name
    publicIpName: firewallPublicIpName
    managementPublicIpName: firewallManagementPublicIpName
    zones: firewallZones
    tags: tags
  }
}

module firewallDiagnostics 'diagnostic-setting.bicep' = if (isHub) {
  name: 'firewall-diagnostics'
  params: {
    resourceKind: 'azureFirewall'
    resourceName: firewall!.outputs.name
    workspaceId: workspaceId
  }
}

module virtualNetwork 'virtual-network.bicep' = {
  name: 'virtual-network'
  dependsOn: [
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
          ? resourceId('Microsoft.Network/networkSecurityGroups', networkSecurityGroupNames[subnetName])
          : null
        routeTableId: contains(routedSubnetNames, subnetName)
          ? resourceId('Microsoft.Network/routeTables', routeTableName)
          : null
      }
    ]
    tags: tags
  }
}

module hubPeering 'vnet-peering.bicep' = if (!isHub) {
  name: 'peering-hub'
  params: {
    virtualNetworkName: virtualNetwork.outputs.name
    name: hubPeeringName
    remoteVirtualNetworkId: hubNetworkId
  }
}

module spokePeerings 'vnet-peering.bicep' = [
  for (spoke, index) in (isHub ? spokes : []): {
    name: 'peering-${spoke.subscription}'
    params: {
      virtualNetworkName: virtualNetwork.outputs.name
      name: spoke.peeringName
      remoteVirtualNetworkId: spokeNetworkIds[index]
    }
  }
]

module privateDnsZones 'private-dns-zone.bicep' = [
  for zoneName in (isHub ? privateDnsZoneNames : []): {
    name: 'dns-${zoneName}'
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

// The hub's network and its private DNS zones carry a CanNotDelete lock: every spoke and every private endpoint depends on them.
module hubNetworkLock 'lock.bicep' = if (isHub) {
  name: 'lock-virtual-network'
  params: {
    resourceKind: 'virtualNetwork'
    resourceName: virtualNetwork.outputs.name
  }
}

module privateDnsZoneLocks 'lock.bicep' = [
  for (zoneName, index) in (isHub ? privateDnsZoneNames : []): {
    name: 'lock-dns-${zoneName}'
    params: {
      resourceKind: 'privateDnsZone'
      resourceName: privateDnsZones[index].outputs.name
    }
  }
]

output virtualNetworkName string = virtualNetwork.outputs.name
output virtualNetworkId string = virtualNetwork.outputs.id
output subnetIds object = virtualNetwork.outputs.subnetIds
output networkSecurityGroupSubnetNames array = networkSecurityGroupSubnetNames
output networkSecurityGroupResourceNames array = [
  for (subnetName, index) in networkSecurityGroupSubnetNames: networkSecurityGroups[index].outputs.name
]
output privateDnsZoneIds array = [
  for (zoneName, index) in (isHub ? privateDnsZoneNames : []): privateDnsZones[index].outputs.id
]
