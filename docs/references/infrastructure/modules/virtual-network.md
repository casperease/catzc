# infrastructure/modules/virtual-network.bicep

The reusable module for a virtual network with its subnets declared inline.

## Subnets are owned here

A virtual network owns its subnets: redeploying a network whose subnet list omits a subnet tries to delete that subnet. The network a
template deploys therefore lists every subnet here. `subnet.bicep` is for adding a subnet to a network the template does not deploy.

## Attachments

Each subnet may carry a network security group (`nsg.bicep`) and a route table (`route-table.bicep`).

## Use

A template references it with a relative `module` declaration (`../../modules/virtual-network.bicep`), and `bicep build` inlines it.
