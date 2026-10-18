# pwsh/Catzc.Azure/Get-AzureEnvironment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the resolved environment object: identity + the named subscription that serves it.

### description

Reads configs/azure.yml via Get-Config and composes an ordered dictionary with the environment's identity fields (name, shortcode, region,
region_code) and the serving subscription (via Get-AzureSubscription). The subscription is named directly — the deploy path resolves it from
the az session and passes it in — so it is an explicit input here. Asserts the subscription actually serves the environment. The embedded
subscription's optional `customer` is what renders into resource names. See
[ADR-AZ-DATAMOD#4](../../../adr/azure/azure-data-model.md#rule-adr-az-datamod4).

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
