# infrastructure/modules/route-table.bicep

The reusable module for a route table of user-defined routes.

## Routes

The caller passes the routes in the ARM `routes` shape: `{ name, properties: { addressPrefix, nextHopType, nextHopIpAddress? } }`.

## Use

Attach the table to a subnet through `virtual-network.bicep` or `subnet.bicep`. `az bicep build` inlines the module.
