<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliIsConnected.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
---
#>

<#
.SYNOPSIS
    Tests whether the active az CLI session is logged into the named tenant + subscription.
.DESCRIPTION
    Takes the subscription name because a connection is subscription-scoped; a mismatch returns false, never throws.
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliIsConnected.ps1.md#comment1)
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
