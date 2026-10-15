# catzc:
#   path: automation/Catzc.Azure.Cli/Assert-AzCliCanAccess.ps1
#   module: Catzc.Azure.Cli
#   visibility: public

<#
.SYNOPSIS
    Asserts the current az CLI login can reach the named subscription.
.DESCRIPTION
    Asks whether the login can reach the subscription, not whether the session is set to it.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md),
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md#comment1)
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
