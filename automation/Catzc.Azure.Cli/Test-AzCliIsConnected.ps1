<#
.SYNOPSIS
    Tests whether the active az CLI session is logged into the named tenant + subscription.
.DESCRIPTION
    Returns $true when `az account show` reports the tenant + subscription that azure.yml resolves for
    the named subscription (via Get-AzureSubscription), $false otherwise (including not-logged-in). A pure
    query — it never throws on a mismatch. Use Assert-AzCliIsConnected for the throwing companion (with a
    remediation message). A connection is subscription-scoped, so the input is the subscription name;
    delegates to the generic Test-AzCliConnected.
.PARAMETER Subscription
    Subscription name (a key in azure.yml's subscriptions).
.EXAMPLE
    if (Test-AzCliIsConnected shared_nonprod) { Deploy-Bicep dev sample }
#>
function Test-AzCliIsConnected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription

    Test-AzCliConnected `
        -SubscriptionId $subscriptionDescriptor.id `
        -TenantId $subscriptionDescriptor.tenant.id
}
