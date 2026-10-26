# pwsh/Azure.Cli/Get-CurrentAzSubscription.ps1

The function that returns the Azure CLI's currently active subscription as a subscription-context record.

## help

### synopsis

Returns the Azure CLI's currently active subscription.

### description

Thin wrapper over `az account show` (via Invoke-AzCli) returning the active subscription as an object (Id, Name, TenantId, State,
IsDefault). This is a data read, so the underlying call is silenced. Throws with remediation when there is no active context (e.g. not
logged in).

Pairs with Set-CurrentAzSubscription for a save / switch / restore idiom:

```text
$original = Get-CurrentAzSubscription
try     { Set-CurrentAzSubscription -SubscriptionId $target; do-stuff}
finally { Set-CurrentAzSubscription -SubscriptionId $original.Id }
```

### example 1

```powershell
Get-CurrentAzSubscription
```

### example 2

```powershell
(Get-CurrentAzSubscription).Id
```
