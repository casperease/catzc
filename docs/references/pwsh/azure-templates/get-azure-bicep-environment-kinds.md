# pwsh/Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1

The function that returns the template environment kinds, which environment class a template binds to.

## help

### synopsis

Returns the supported template environment kinds (which env class a template binds to).

### description

'standard' (default) — the template's configs use standard environments (dev/test/preprod/prod),

```text
which may appear many-per-subscription.
```

'subscription' — the template's configs use per-subscription environments (nsub/psub),

```text
which appear exactly once per subscription. See
[ADR-AZ-DATAMOD](/docs/drs/azure/azure-data-model.md).
```

### example 1

```powershell
Get-AzureBicepEnvironmentKinds
```
