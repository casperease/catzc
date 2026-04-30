<#
.SYNOPSIS
    Tests whether the current az CLI login can reach the named subscription.
.DESCRIPTION
    The azure.yml-aware companion to the generic Test-AzCliSubscriptionAccessible: it takes
    a subscription *name* (a key in azure.yml's subscriptions), resolves it to a subscription id via
    Get-AzureSubscription, and delegates the real-ARM-read access check down. Returns $true when the
    current login can reach the subscription, $false otherwise (including not logged in). A pure query —
    it never throws on a mismatch. Use Assert-AzCliCanAccess for the throwing companion.

    "IsConnected" asks whether the session is *set to* the subscription; "CanAccess" asks whether the
    current login can *reach* it, independent of which subscription is active.
    See docs/adr/azure/data-model.md and docs/adr/automation/prefer-az-cli.md#rule-adr-azcli1.
.PARAMETER Subscription
    Subscription name (a key in azure.yml's subscriptions).
.EXAMPLE
    if (Test-AzCliCanAccess apex_nonprod) { Deploy-Bicep develop sample -Subscription apex_nonprod }
#>
function Test-AzCliCanAccess {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    Test-AzCliSubscriptionAccessible -SubscriptionId $subscriptionDescriptor.id
}
