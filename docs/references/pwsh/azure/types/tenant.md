# pwsh/Azure/types/Tenant.cs

An Entra ID tenant, the directory boundary that owns one or more subscriptions. It is the leaf of the resolved identity graph, `Tenant`,
then `AzureSubscription`, then `AzureEnvironment`. The type mirrors one entry of the `tenants` map in `configs/azure.yml`, so the property
names are the YAML keys verbatim.
