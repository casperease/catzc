# pwsh/Azure.Cli/Assert-AzCliIsConnected.ps1

The throwing check that the active az session is logged into the tenant and subscription a declared subscription name stands for. It
resolves the name through `azure.yml` and delegates the comparison to the connection-state function.

## help

### synopsis

Asserts the active az CLI session is logged into the tenant + subscription named.

### description

The throwing companion to Test-AzCliIsConnected (which returns a bool). Throws a remediation-bearing error when az is not logged in, or is
logged into the wrong tenant / subscription. A connection is subscription-scoped, so the input is the subscription name: it resolves the
subscription + tenant from azure.yml (Get-AzureSubscription) and delegates the check to the generic Get-AzCliConnectionState. See
[ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md).

### parameter `Subscription`

Subscription name (a key in azure.yml's subscriptions).

### example 1

```powershell
Assert-AzCliIsConnected shared_nonprod
```

### example 2

```powershell
Assert-AzCliIsConnected apex_nonprod
```
