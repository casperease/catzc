# pwsh/Azure.Templates/Get-BicepServiceConnections.ps1

The service connections a project needs, derived rather than listed. `service-connections.yml` declares the deployment identities, each with
the templates it deploys and the Azure role it holds; the subscription is the trust boundary, so each identity gets one connection in each
subscription where one of its templates has a slot. Every connection spans its subscription: the workload identity deploys into several
resource groups, and its least privilege is the role assignments the templates grant (`Get-BicepRoleAssignmentPlan`), never the connection's
scope.

## help

### synopsis

Lists the service connections derived from the deployment identities, one per identity in each subscription that hosts a slot of its
templates.

### description

Reads the identities of `service-connections.yml` and the slots of every template (`Get-BicepTemplates`), and returns one
`BicepServiceConnection` per identity and subscription where a slot of one of the identity's templates lives, in `azure.yml` subscription
order and then identity order. Each connection is named by `Get-BicepServiceConnectionName` and carries the identity's name, role segment,
`roles.yml` role, templates and description. An identity whose Azure role `roles.yml` does not name, or whose template does not exist,
fails, as do two subscriptions whose coordinates derive one connection name.

### parameter `Subscription`

The `azure.yml` subscriptions to list the connections of; every subscription when omitted.

### example 1

```powershell
Get-BicepServiceConnections | Format-Table name, identity, subscription, azure_role
```

### example 2

```powershell
Get-BicepServiceConnections -Subscription apex_prod
```
