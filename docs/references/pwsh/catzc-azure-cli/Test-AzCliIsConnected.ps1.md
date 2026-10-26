# pwsh/Azure.Cli/Test-AzCliIsConnected.ps1

The query twin of the is-connected assertion: it returns a bool for whether the active az session is logged into the tenant and
subscription a declared subscription name stands for.

## help

### synopsis

Tests whether the active az CLI session is logged into the named tenant + subscription.

### description

Returns
$true when `az account show` reports the tenant + subscription that azure.yml resolves for
the named subscription (via Get-AzureSubscription), $false
otherwise (including not-logged-in). A pure query — it never throws on a mismatch. Use Assert-AzCliIsConnected for the throwing companion
(with a remediation message). A connection is subscription-scoped, so the input is the subscription name; delegates to the generic
Test-AzCliConnected.

### parameter `Subscription`

Subscription name (a key in azure.yml's subscriptions).

### example 1

```powershell
if (Test-AzCliIsConnected shared_nonprod) { Deploy-Bicep dev sample }
```
