# infrastructure/modules/vnet-peering.bicep

The reusable module for one side of a virtual network peering, on a local network towards a remote one. The remote network may live in
another subscription.

## Two sides

A peering is two-sided: the hub deploys hub to spoke and the spoke deploys spoke to hub, each with this module. `bicep build` inlines the
module.
