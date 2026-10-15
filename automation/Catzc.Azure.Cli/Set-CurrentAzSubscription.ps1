<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Set-CurrentAzSubscription.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Sets the Azure CLI's active subscription.
.DESCRIPTION
    It mutates the CLI context, so the call stays loud, unlike the silenced read in Get-CurrentAzSubscription.
    [comment:1](/docs/references/automation/catzc-azure-cli/Set-CurrentAzSubscription.ps1.md#comment1)
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
