# pwsh/Catzc.Azure.Cli/Get-CurrentAzSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
