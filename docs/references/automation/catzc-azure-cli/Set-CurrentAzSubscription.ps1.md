# automation/Catzc.Azure.Cli/Set-CurrentAzSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Sets the Azure CLI's active subscription.

### description

Thin wrapper over `az account set --subscription` (via Invoke-AzCli). This mutates the CLI context, so
it is a loud action call (not silenced). Throws with remediation if the subscription can't be selected
(wrong ID, or the identity lacks access).

Unlike Assert-AzCliConnected, which only asserts the session is already on an expected subscription,
this deliberately switches it. Pairs with Get-CurrentAzSubscription for save / switch / restore.

### parameter SubscriptionId

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
