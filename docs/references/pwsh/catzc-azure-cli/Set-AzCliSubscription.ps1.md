# pwsh/Catzc.Azure.Cli/Set-AzCliSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Sets the active Azure CLI subscription.

### description

Skips if the requested subscription is already active.

### parameter `Subscription`

Subscription name or ID.

### example 1

```powershell
Set-AzCliSubscription 'my-subscription'
```

### example 2

```powershell
Set-AzCliSubscription '50a0ed00-de00-50b0-0000-000000000000'
```

## comment:1

Above `$result = Invoke-Executable 'az account show --output json' -PassThru...`, written with `#`.

```text
Idempotent: skip if already on the requested subscription
-NoAssert: non-zero exit means "not logged in" — falls through to az account set
```
