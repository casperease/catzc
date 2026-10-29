# pwsh/Azure/Get-AzureSubscriptionEnvironment.ps1

The lookup of a subscription's identity environment, `nsub` or `psub`. A template of the standard kind uses it to find the
once-per-subscription template deployed in the same subscription.

## help

### synopsis

Returns the per-subscription identity environment (nsub/psub) of a named subscription.

### description

Each subscription carries exactly one per-subscription env (nsub or psub — see [ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md)),
the identity env that subscription-kind templates deploy once-per-subscription. This returns it for a named subscription, so a standard-kind
template can locate the once-per-subscription foundation (and its Key Vault) that lives in the same subscription.

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
