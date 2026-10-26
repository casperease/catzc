# pwsh/Azure/Get-AzureEnvironment.ps1

The resolver for an environment identity joined to the subscription that serves it. Deployment code needs the region, the codes and the
subscription together, and this builds that one object and checks that the pair is a real one.

## help

### synopsis

Returns the resolved environment object: identity + the named subscription that serves it.

### description

Reads configs/azure.yml via Get-Config and composes an ordered dictionary with the environment's identity fields (name, shortcode, region,
region_code) and the serving subscription (via Get-AzureSubscription). The subscription is named directly — the deploy path resolves it from
the az session and passes it in — so it is an explicit input here. Asserts the subscription actually serves the environment. The embedded
subscription's optional `customer` is what renders into resource names. See
[ADR-AZ-DATAMOD-CUSTOMERAXIS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-customeraxis).

### parameter `Environment`

Environment name. Must be a key in azure.yml's `environments` map.

### parameter `Subscription`

Subscription name — a key in azure.yml's `subscriptions`. Must serve the environment.

### example 1

```powershell
$env = Get-AzureEnvironment dev -Subscription shared_nonprod
$env.region
$env.subscription.id
```

### example 2

```powershell
$env = Get-AzureEnvironment dev -Subscription apex_nonprod   # .subscription.customer is apex
```
