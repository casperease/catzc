# pwsh/Azure/Get-AzureSubscriptionCustomer.ps1

The one accessor for the `customer` field of a subscription entry. Two resolvers read that field, and keeping the read in one place stops
them from drifting apart.

## help

### synopsis

Returns the customer a subscription is bound to (its `customer` field), or '' if it has none.

### description

A customer subscription carries a `customer` field — a customer.yml customer, by key or shortcode; its presence is the single signal that
the subscription belongs to a customer (and the customer renders into the resource names of anything deployed there). Non-customer
subscriptions have none. This is the single accessor for that field, shared by Get-AzureSubscription (naming resolution) and
Get-BicepConfigSubscriptionCandidates (config-coordinate resolution) so the two cannot drift.

### parameter `Subscription`

A subscription entry (an AzureSubscriptionRecord) from azure.yml's `subscriptions` map.

### example 1

```powershell
Get-AzureSubscriptionCustomer $sub   # -> 'apex' (a customer subscription) else ''
```
