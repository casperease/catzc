<#
.SYNOPSIS
    Returns the customer a subscription is bound to (its `customer` field), or '' if it has none.
.DESCRIPTION
    A customer subscription carries a `customer` field — a key in azure.yml's `customers`; its presence
    is the single signal that the subscription belongs to a customer (and the customer renders into the
    resource names of anything deployed there). Non-customer subscriptions have none. This is the single
    accessor for that field, shared by Assert-AzureConfig (validation) and Get-AzureSubscription
    (naming resolution) so the two cannot drift.
.PARAMETER Subscription
    A subscription entry (ordered dict) from azure.yml's `subscriptions` map.
.EXAMPLE
    Get-AzureSubscriptionCustomer $sub   # -> 'apex' (a customer subscription) else ''
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
