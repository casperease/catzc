<#
.SYNOPSIS
    Sets the Azure CLI's active subscription.
.DESCRIPTION
    Thin wrapper over `az account set --subscription` (via Invoke-AzCli). This mutates the CLI context, so
    it is a loud action call (not silenced). Throws with remediation if the subscription can't be selected
    (wrong ID, or the identity lacks access).

    Unlike Assert-AzCliConnected, which only asserts the session is already on an expected subscription,
    this deliberately switches it. Pairs with Get-CurrentAzSubscription for save / switch / restore.
.PARAMETER SubscriptionId
    The subscription GUID (or display name) to make active.
.EXAMPLE
    Set-CurrentAzSubscription -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
.EXAMPLE
    $original = Get-CurrentAzSubscription
    try     { Set-CurrentAzSubscription -SubscriptionId $target; do-stuff }
    finally { Set-CurrentAzSubscription -SubscriptionId $original.Id }
#>
function Set-CurrentAzSubscription {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$SubscriptionId
    )

    try {
        # Action / mutation — stays loud.
        Invoke-AzCli "account set --subscription $SubscriptionId"
    }
    catch {
        throw "Failed to set the active subscription to '$SubscriptionId'. Verify the ID and that your identity has access. Underlying: $_"
    }
}
