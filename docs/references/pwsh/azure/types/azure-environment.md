# pwsh/Azure/types/AzureEnvironment.cs

A resolved environment identity: a named deployment environment paired with the subscription that serves it. It is the root of the identity
graph, `AzureEnvironment`, then `AzureSubscription`, then `Tenant`. The name and the short codes compose Azure resource names per the naming
standard. The type mirrors an `environments` entry of `configs/azure.yml` joined to its serving subscription, so the property names are the
YAML keys.
