# pwsh/Azure.Templates/Get-BicepServiceConnectionName.ps1

The one naming rule of a service connection: the resource namer with type `sc`, fed the subscription's coordinates and the identity's role,
so a connection's name says which subscription it reaches and what it may do there.

## help

### synopsis

Returns the name of one deployment identity's service connection in one subscription, from the subscription's coordinates and the identity's
role.

### description

Resolves the subscription's per-subscription environment (`nsub`, `psub`) with its region code, the `azure.yml` org, the subscription's
customer when it has one, the `short_name` of `service-connections.yml` and the identity's `role`, and names them through
`Get-AzureResourceName` with type `sc` (long pattern, at most 256 characters) in the repository's name order.

### parameter `Subscription`

The `azure.yml` subscription the connection reaches.

### parameter `Identity`

The `service-connections.yml` identity the connection realises, such as `landing-zone`.

### example 1

```powershell
Get-BicepServiceConnectionName apex_nonprod landing-zone
```
