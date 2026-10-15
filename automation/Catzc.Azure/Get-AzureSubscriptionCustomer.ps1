<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureSubscriptionCustomer.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
---
#>

<#
.SYNOPSIS
    Returns the customer a subscription is bound to (its `customer` field), or '' if it has none.
.DESCRIPTION
    The one accessor for this field, shared by naming and config-coordinate resolution so the two cannot drift.
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
