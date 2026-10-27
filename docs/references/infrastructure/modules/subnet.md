# infrastructure/modules/subnet.bicep

The reusable module that adds one subnet to an existing virtual network which the template does not deploy itself.

## Why it is the exception

A virtual network the template deploys declares all its subnets inline (`virtual-network.bicep`), because redeploying a network without one
of its subnets tries to delete that subnet. Use this module only for a network owned elsewhere. `bicep build` inlines it.
