# pwsh/Azure.DevOps/Sync-AdoServiceConnections.ps1

The command that applies `service-connections.yml` to Azure DevOps: one Azure service connection per configured subscription, each
authenticating by workload identity federation.

## help

### synopsis

Creates or updates the project's Azure service connections from service-connections.yml, every one federated.

### description

Reads each configured connection and its subscription's id and tenant from azure.yml, then creates a missing connection, converts one that
authenticates any other way to workload identity federation in place (so the pipelines that name it keep working), and leaves a federated
one on the right subscription alone. Each connection is an azurerm endpoint whose identity Azure DevOps creates. It returns one record per
connection, with its action: Create, Update or Unchanged. The organization and project come from ado.yml.

### parameter `Project`

The Azure DevOps project. Default: ado.yml's project.

### parameter `Organization`

The organization URL, `https://dev.azure.com/<org>`. Default: ado.yml's organization.

### parameter `DryRun`

Reads the organization and reports each connection's action, writing nothing.

### example 1

```powershell
Sync-AdoServiceConnections -DryRun
```

### example 2

```powershell
Sync-AdoServiceConnections
```
