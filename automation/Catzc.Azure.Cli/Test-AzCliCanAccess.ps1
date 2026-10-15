<#
.SYNOPSIS
    Tests whether the current az CLI login can reach the named subscription.
.DESCRIPTION
    Asks whether the login can reach the subscription, independent of which subscription is the active one.
    [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md),
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliCanAccess.ps1.md#comment1)
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
