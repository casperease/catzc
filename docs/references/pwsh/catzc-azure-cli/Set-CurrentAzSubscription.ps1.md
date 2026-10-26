# pwsh/Azure.Cli/Set-CurrentAzSubscription.ps1

The command that sets the Azure CLI's active subscription from a subscription-context record, the counterpart that restores what the
current-subscription getter captured.

## help

### synopsis

Sets the Azure CLI's active subscription.

### description

Thin wrapper over `az account set --subscription` (via Invoke-AzCli). This mutates the CLI context, so it is a loud action call (not
silenced). Throws with remediation if the subscription can't be selected (wrong ID, or the identity lacks access).

Unlike Assert-AzCliConnected, which only asserts the session is already on an expected subscription, this deliberately switches it. Pairs
with Get-CurrentAzSubscription for save / switch / restore.

### parameter `SubscriptionId`

The subscription GUID (or display name) to make active.

### example 1

```powershell
Set-CurrentAzSubscription -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
```

### example 2

```powershell
$original = Get-CurrentAzSubscription
try     { Set-CurrentAzSubscription -SubscriptionId $target; do-stuff }
finally { Set-CurrentAzSubscription -SubscriptionId $original.Id }
```
