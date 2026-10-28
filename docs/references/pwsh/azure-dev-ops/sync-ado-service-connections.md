# pwsh/Azure.DevOps/Sync-AdoServiceConnections.ps1

The command that applies the given service connections to Azure DevOps, such as those `Get-BicepServiceConnections` derives from
`service-connections.yml`: one Azure service connection per deployment identity and subscription, each authenticating by workload identity
federation.

## help

### synopsis

Creates or updates the project's Azure service connections from the given connections, every one federated.

### description

Takes each connection from the pipeline or `-Connection` and reads its subscription's id and tenant from azure.yml, then creates a missing
connection, converts one that authenticates any other way, sits on another subscription or at another scope level to workload identity
federation in place (so the pipelines that name it keep working), and leaves a matching one alone. Each connection is an azurerm endpoint
whose identity Azure DevOps creates, spanning its subscription; what each identity may do there is the role assignments the templates grant
it. It reads the project once and returns one record per connection, with its action: Create, Update or Unchanged. The organization and
project come from ado.yml.

### parameter `Connection`

The connections to apply, each with its name, subscription and description, as `Get-BicepServiceConnections` lists them. Takes pipeline
input.

### parameter `Project`

The Azure DevOps project. Default: ado.yml's project.

### parameter `Organization`

The organization URL, `https://dev.azure.com/<org>`. Default: ado.yml's organization.

### parameter `DryRun`

Reads the organization and reports each connection's action, writing nothing.

### example 1

```powershell
Get-BicepServiceConnections | Sync-AdoServiceConnections -DryRun
```

### example 2

```powershell
Get-BicepServiceConnections | Sync-AdoServiceConnections
```
