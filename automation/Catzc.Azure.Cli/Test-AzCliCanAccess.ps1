<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliCanAccess.ps1
    kind: gate-function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD
---
#>

<#
.SYNOPSIS
    Tests whether the current az CLI login can reach the named subscription.
.DESCRIPTION
    Asks whether the login can reach the subscription, independent of which subscription is the active one.
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
