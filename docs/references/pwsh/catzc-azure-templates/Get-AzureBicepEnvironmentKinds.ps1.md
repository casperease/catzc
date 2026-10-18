# automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
```

### example 1

```powershell
Get-AzureBicepEnvironmentKinds
```
