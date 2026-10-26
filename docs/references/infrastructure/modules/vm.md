# infrastructure/modules/vm.bicep

The reusable module for a Windows virtual machine with its network interface and a dynamic public IP.

## Network

The module takes an existing subnet: create the network with `../../modules/virtual-network.bicep` and pass one of its subnet ids.

## Size

The default is the cheapest SKU (`Standard_B1s`), because this is a proof-of-concept machine. `az bicep build` inlines the module.
