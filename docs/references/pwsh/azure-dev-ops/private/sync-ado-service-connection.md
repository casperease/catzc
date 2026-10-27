# pwsh/Azure.DevOps/private/Sync-AdoServiceConnection.ps1

The function that brings one Azure service connection to its configured shape for `Sync-AdoServiceConnections`.

## help

### synopsis

Creates, converts or leaves one Azure service connection, federated by workload identity.

### description

Reads the connection by name. A missing one is created as an azurerm endpoint with the WorkloadIdentityFederation scheme, its identity
created by Azure DevOps. One with another scheme, or on another subscription, is converted in place with the ConvertAuthenticationScheme
operation. A federated one on the right subscription is left alone. Returns the action: Create, Update or Unchanged.

### parameter `Context`

The organization, project, project id and API base.

### parameter `Connection`

The configured connection: its name, subscription and description.

### parameter `Subscription`

The connection's subscription from azure.yml: its name, id and tenant.

### parameter `DryRun`

Reports the action, writing nothing.

### example 1

```powershell
Sync-AdoServiceConnection -Context $context -Connection $connection -Subscription $subscription -DryRun
```
