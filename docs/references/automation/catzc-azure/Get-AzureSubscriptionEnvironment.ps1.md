# automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the per-subscription identity environment (nsub/psub) of a named subscription.

### description

Each subscription carries exactly one per-subscription env (nsub or psub — see [ADR-AZ-DATAMOD](../../../adr/azure/azure-data-model.md)),
the identity env that environment_kind:subscription templates deploy once-per-subscription. This returns it for a named subscription, so an
environment_kind:standard template can locate the once-per-subscription foundation (and its Key Vault) that lives in the same subscription.

### parameter `Subscription`

Subscription name — a key in azure.yml's `subscriptions`.

### example 1

```powershell
Get-AzureSubscriptionEnvironment shared_nonprod   # -> nsub
```

### example 2

```powershell
Get-AzureSubscriptionEnvironment apex_prod         # -> psub
```
