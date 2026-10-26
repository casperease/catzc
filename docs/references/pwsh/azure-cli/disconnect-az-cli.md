# pwsh/Azure.Cli/Disconnect-AzCli.ps1

The command that logs out of the Azure CLI. It is idempotent: with no login it does nothing.

## help

### synopsis

Logs out of Azure CLI.

### description

Skips if not currently logged in.

### example 1

```powershell
Disconnect-AzCli
```

## Idempotent logout

The command first runs `az account show` and skips the logout when no one is logged in. That probe passes `-NoAssert`, because a non-zero
exit only means "not logged in", an expected state and not an error.
