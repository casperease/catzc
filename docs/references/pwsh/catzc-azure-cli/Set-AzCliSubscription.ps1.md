# pwsh/Azure.Cli/Set-AzCliSubscription.ps1

The command that sets the active Azure CLI subscription. It is idempotent: a session already on the requested subscription is left alone.

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

## Idempotent set

The command first runs `az account show` and skips the change when the session is already on the requested subscription. That probe passes
`-NoAssert`, because a non-zero exit only means "not logged in", and the command then falls through to `az account set`.
