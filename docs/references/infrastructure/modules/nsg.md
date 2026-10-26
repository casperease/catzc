# infrastructure/modules/nsg.bicep

The reusable module for a network security group.

## Rules

The caller passes the rules in the ARM `securityRules` shape: `{ name, properties: { priority, direction, access, protocol, … } }`. The
Azure default rules (allow virtual network and load-balancer inbound, deny all other inbound) always apply beneath them.

## Use

Attach the group to a subnet through `virtual-network.bicep` or `subnet.bicep`. `az bicep build` inlines the module.
