# automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
independent of which subscription is active. See [ADR-AZ-DATAMOD](../../../adr/azure/azure-data-model.md) and
[ADR-AZ-CLI#1](../../../adr/azure/prefer-az-cli.md#rule-adr-az-cli1).

### parameter `Subscription`

Subscription name (a key in azure.yml's subscriptions).

### example 1

```powershell
if (Test-AzCliCanAccess apex_nonprod) { Deploy-Bicep develop sample -Subscription apex_nonprod }
```
