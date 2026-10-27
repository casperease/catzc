# infrastructure/modules/vm.bicep

The reusable module for a Windows virtual machine with its network interface, and a dynamic public IP only when public access is asked for.

## Network

The module takes an existing subnet: create the network with `../../modules/virtual-network.bicep` and pass one of its subnet ids.

Public network access is off by default (`publicNetworkAccess`, default `Disabled`), like the Key Vault's: the machine then has no public IP
and is reached through its network. Set `Enabled`, with a `publicIpName`, to attach a Basic dynamic public IP to the interface.

## Size

The default is the cheapest SKU (`Standard_B1s`), because this is a proof-of-concept machine. `bicep build` inlines the module.
