<#
.SYNOPSIS
    Tests whether the current az CLI login can reach a given subscription.
.DESCRIPTION
    Returns $true when a real, read-only ARM call scoped to the subscription succeeds with the current login; $false...
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
