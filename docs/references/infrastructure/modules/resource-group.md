# infrastructure/modules/resource-group.bicep

The reusable module for a resource group. It deploys at subscription level (`targetScope = 'subscription'`).

## Use

A template that deploys at subscription level creates its resource groups with this module, then deploys resource-group modules into them
with `scope: resourceGroup(<name>)`. `az bicep build` inlines the module.
