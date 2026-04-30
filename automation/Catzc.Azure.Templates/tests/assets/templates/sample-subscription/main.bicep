// Subscription-scoped sample template. Exercises the `Subscription` deployment target
// (declared in options.yml) — deployed with `az deployment sub create`, no resource group.
//
// Creates one resource group at subscription scope. `region` defaults to the deployment's
// own location (the `--location` az passes), so configuration/<slot>.yml only needs to name
// the resource group.

targetScope = 'subscription'

param resourceGroupName string
param region string = deployment().location

resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: region
}

output resourceGroupId string = rg.id
