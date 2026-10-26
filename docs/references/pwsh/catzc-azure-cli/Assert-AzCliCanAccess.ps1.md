# pwsh/Azure.Cli/Assert-AzCliCanAccess.ps1

The throwing check, by subscription name, that the current az login can reach that subscription. It resolves the name through
`azure.yml` and delegates the access probe to the generic subscription-accessible assertion.

## help

### synopsis

Asserts the current az CLI login can reach the named subscription.

### description

The azure.yml-aware companion to the generic Assert-AzCliSubscriptionAccessible: it takes a subscription _name_ (a key in azure.yml's
subscriptions), resolves it to a subscription id via Get-AzureSubscription, and delegates the real-ARM-read access check down. Drop it at
the top of a function to fail fast before it calls az against that subscription — whether the subscription is the active one or supplied via
`--subscription <id>`.

This is to access what Assert-AzCliIsConnected is to active-context: same name resolution, different question. "IsConnected" asks whether
the session is `*set` `to*` the subscription; "CanAccess" asks whether the current login can _reach_ it, independent of which subscription
is active. See [ADR-AZ-DATAMOD](../../../drs/azure/azure-data-model.md) and
[ADR-AZ-CLI-AZBYDEFAULT](../../../drs/azure/prefer-az-cli.md#rule-adr-az-cli-azbydefault).

### parameter `Subscription`

Subscription name (a key in azure.yml's subscriptions).

### example 1

```powershell
Assert-AzCliCanAccess apex_nonprod
```

### example 2

```powershell
Assert-AzCliCanAccess shared_nonprod
```
