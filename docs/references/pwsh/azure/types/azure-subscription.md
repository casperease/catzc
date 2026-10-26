# pwsh/Azure/types/AzureSubscription.cs

A resolved subscription identity: a named Azure subscription, the Entra tenant that owns it and, for customer subscriptions only, the
customer it serves. It is the middle node of the identity graph, `Tenant`, then `AzureSubscription`, then `AzureEnvironment`. The type
mirrors a `subscriptions` entry of `configs/azure.yml`, so the property names are the YAML keys verbatim.

## customer

`customer` is the customer this subscription serves, and the value renders into customer resource names. It is null for a non-customer
(platform or shared) subscription, so a typed null check separates the two kinds.
