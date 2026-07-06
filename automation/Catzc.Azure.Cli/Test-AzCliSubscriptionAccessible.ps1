<#
.SYNOPSIS
    Tests whether the current az CLI login can reach a given subscription.
.DESCRIPTION
    Returns $true when a real, read-only ARM call scoped to the subscription succeeds with the current
    login; $false otherwise (including not logged in). A pure query — it never throws on a mismatch.
    Use Assert-AzCliSubscriptionAccessible for the throwing companion. Both share
    Get-AzCliSubscriptionAccessState.

    Unlike Test-AzCliConnected (which asks "is this subscription the active one?"), this asks "can my
    current login reach this subscription?", independent of the active context — the question to ask
    before a call that supplies `--subscription <id>`.
    See docs/adr/automation/powershell/prefer-az-cli.md#rule-adr-azcli1.
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
