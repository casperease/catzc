<#
.SYNOPSIS
    Asserts the active az CLI session is logged into the tenant + subscription named.
.DESCRIPTION
    The throwing companion to Test-AzCliIsConnected (which returns a bool). Throws a remediation-bearing
    error when az is not logged in, or is logged into the wrong tenant / subscription. A connection is
    subscription-scoped, so the input is the subscription name: it resolves the subscription + tenant
    from azure.yml (Get-AzureSubscription) and delegates the check to the generic Get-AzCliConnectionState.
    See docs/adr/azure/azure-data-model.md.
.PARAMETER Subscription
    Subscription name (a key in azure.yml's subscriptions).
.EXAMPLE
    Assert-AzCliIsConnected shared_nonprod
.EXAMPLE
    Assert-AzCliIsConnected apex_nonprod
#>
function Assert-AzCliIsConnected {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription

    $state = Get-AzCliConnectionState `
        -SubscriptionId $subscriptionDescriptor.id `
        -TenantId $subscriptionDescriptor.tenant.id

    if (-not $state.logged_in) {
        throw "Not logged in to az CLI. Run: az login --tenant $($state.expected_tenant)"
    }
    if (-not $state.connected) {
        throw (
            "az CLI is logged into the wrong context for subscription '$Subscription'. " +
            "Expected tenant=$($state.expected_tenant) sub=$($state.expected_subscription); " +
            "got tenant=$($state.actual_tenant) sub=$($state.actual_subscription). " +
            "Run: az login --tenant $($state.expected_tenant); az account set --subscription $($state.expected_subscription)"
        )
    }
}
