# infrastructure/modules/private-endpoint.bicep

The reusable module for a private endpoint to one sub-resource of a target service, such as the `blob` of a storage account or the
`sqlServer` of a SQL server.

## What it deploys

The endpoint sits in a subnet and carries a private DNS zone group that registers its address in the given private DNS zones. Those zones
may live in the hub's subscription.

## Use

`bicep build` inlines the module into the template that references it.
