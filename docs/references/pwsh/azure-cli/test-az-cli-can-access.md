# pwsh/Azure.Cli/Test-AzCliCanAccess.ps1

The query twin of the can-access assertion: it returns a bool for whether the current az login can reach a subscription named in
`azure.yml`.

## help

### synopsis

Tests whether the current az CLI login can reach the named subscription.

### description

The azure.yml-aware companion to the generic Test-AzCliSubscriptionAccessible: it takes a subscription _name_ (a key in azure.yml's
subscriptions), resolves it to a subscription id via Get-AzureSubscription, and delegates the real-ARM-read access check down. Returns
$true when the
current login can reach the subscription, $false otherwise (including not logged in). A pure query — it never throws on a
mismatch. Use Assert-AzCliCanAccess for the throwing companion.

"IsConnected" asks whether the session is `*set` `to*` the subscription; "CanAccess" asks whether the current login can _reach_ it,
independent of which subscription is active. See [ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md) and
[ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

### parameter `Subscription`

Subscription name (a key in azure.yml's subscriptions).

### example 1

```powershell
if (Test-AzCliCanAccess apex_nonprod) { Deploy-Bicep develop sample -Subscription apex_nonprod }
```
