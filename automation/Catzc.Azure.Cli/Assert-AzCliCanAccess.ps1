<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD
---
#>

<#
.SYNOPSIS
    Asserts the current az CLI login can reach the named subscription.
.DESCRIPTION
    Asks whether the login can reach the subscription, not whether the session is set to it.
.PARAMETER Subscription
    Subscription name (a key in azure.yml's subscriptions).
.EXAMPLE
    Assert-AzCliCanAccess apex_nonprod
.EXAMPLE
    Assert-AzCliCanAccess shared_nonprod
#>
function Assert-AzCliCanAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    Assert-AzCliSubscriptionAccessible -SubscriptionId $subscriptionDescriptor.id
}
