# pwsh/Azure/Get-AzureSubscription.ps1

The by-name resolver for a subscription identity: its id, its embedded tenant and, for a customer subscription, the customer. It is the one
lookup that resolved configuration coordinates and the session reverse lookup build on.

## help

### synopsis

Returns the resolved Azure subscription identity (id + tenant [+ customer]) for a named subscription.

### description

Reads configs/azure.yml via Get-Config and looks up the subscription by name (a key in `subscriptions`) — the by-name identity lookup the
resolved configuration coordinates and the session reverse lookup (Get-AzCliSessionSubscription) build on; there is no (environment, group,
customer) join here. The matching tenant is looked up by name and embedded. A subscription MAY carry a `customer`, named by its key OR its
2-char shortcode (a customer in customer.yml); it is resolved to the canonical key and included (and renders into the resource names of
anything deployed there). See [ADR-AZ-DATAMOD-CUSTOMERAXIS](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-customeraxis) and
[ADR-AZ-CUSTOMER](../../../drs/azure/azure-customer-model.md).

### parameter `Subscription`

Subscription name — a key in azure.yml's `subscriptions`.

### example 1

```powershell
$sub = Get-AzureSubscription shared_nonprod
$sub.id
$sub.tenant.id
```

### example 2

```powershell
(Get-AzureSubscription apex_nonprod).customer   # -> apex
```

## customer

A subscription's `customer` field may hold a customer key or a shortcode. The resolver normalizes it to the canonical key, so the resolved
object is the same whichever form the config used. The value is empty for a subscription that is not a customer subscription. See
[ADR-AZ-CUSTOMER](../../../drs/azure/azure-customer-model.md).
