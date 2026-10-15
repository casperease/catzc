<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureSubscriptionCustomer.ps1
    kind: automation-function
    module: Catzc.Azure
    visibility: public
  config:
    synopsis: Returns the customer a subscription is bound to (its `customer` field), or '' if it has none.
    description: |-
      A customer subscription carries a `customer` field — a customer.yml customer, by key or shortcode; its
      presence is the single signal that the subscription belongs to a customer (and the customer renders into
      the resource names of anything deployed there). Non-customer subscriptions have none. This is the single
      accessor for that field, shared by Get-AzureSubscription (naming resolution) and
      Get-BicepConfigSubscriptionCandidates (config-coordinate resolution) so the two cannot drift.
    parameters:
      Subscription: A subscription entry (an AzureSubscriptionRecord) from azure.yml's `subscriptions` map.
    examples:
      - 'Get-AzureSubscriptionCustomer $sub   # -> ''apex'' (a customer subscription) else '''''
---
#>

function Get-AzureSubscriptionCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Subscription
    )

    if ($Subscription.Contains('customer')) {
        return $Subscription.customer
    }
    ''
}
