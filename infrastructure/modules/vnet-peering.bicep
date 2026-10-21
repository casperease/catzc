// ---
// catzc:
//   immutable:
//     with_body_sha: "489d1b397118"
//   edges:
//     docs: "[vnet-peering.bicep.md](../../docs/references/infrastructure/modules/vnet-peering.bicep.md)"
// ---

@description('Name of the existing local virtual network (in the deployment resource group).')
param virtualNetworkName string

@description('Peering name (1-80 characters, unique within the local VNet).')
param name string

@description('Resource id of the remote virtual network.')
param remoteVirtualNetworkId string

@description('Allow the VMs in the two VNets to reach each other.')
param allowVirtualNetworkAccess bool = true

@description('Accept traffic forwarded by a network virtual appliance in the remote VNet (spoke side, behind a hub firewall).')
param allowForwardedTraffic bool = false

@description('Let the remote VNet use the gateway of this VNet (hub side).')
param allowGatewayTransit bool = false

@description('Use the gateway of the remote VNet (spoke side; needs allowGatewayTransit on the hub side and a deployed gateway).')
param useRemoteGateways bool = false

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: virtualNetworkName
}

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: vnet
  name: name
  properties: {
    remoteVirtualNetwork: {
      id: remoteVirtualNetworkId
    }
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
}

output id string = peering.id
output name string = peering.name
