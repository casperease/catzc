# catzc:
#   path: automation/Catzc.Azure.Cli/Test-AzCliSubscriptionAccessible.ps1
#   module: Catzc.Azure.Cli
#   visibility: public

<#
.SYNOPSIS
    Tests whether the current az CLI login can reach a given subscription.
.DESCRIPTION
    Ask this, not the connected test, before a call that supplies a subscription id, since the active context is moot.
    [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1)
    [comment:1](/docs/references/automation/catzc-azure-cli/Test-AzCliSubscriptionAccessible.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the current login must be able to reach.
.EXAMPLE
    if (Test-AzCliSubscriptionAccessible -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000) { ... }
#>
function Test-AzCliSubscriptionAccessible {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    (Get-AzCliSubscriptionAccessState $SubscriptionId).accessible
}
