<#
.SYNOPSIS
    Returns the customer a subscription is bound to (its `customer` field), or '' if it has none.
.DESCRIPTION
    A customer subscription carries a `customer` field — a customer.yml customer, by key or shortcode; its presence...
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureSubscriptionCustomer.ps1.md#comment1)
.PARAMETER Subscription
    A subscription entry (an AzureSubscriptionRecord) from azure.yml's `subscriptions` map.
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
