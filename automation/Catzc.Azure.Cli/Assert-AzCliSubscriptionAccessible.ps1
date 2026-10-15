<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
    kind: function
    module: Catzc.Azure.Cli
    visibility: public
    adrs:
      - ADR-AUTO-FAILFAST
      - ADR-AZ-CLI#1
---
#>

<#
.SYNOPSIS
    Asserts the current az CLI login can reach a given subscription.
.DESCRIPTION
    A pass proves a real ARM call will work, not merely that the subscription is in the local profile.
    [comment:1](/docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md#comment1)
.PARAMETER SubscriptionId
    The subscription GUID the current login must be able to reach.
.EXAMPLE
    Assert-AzCliSubscriptionAccessible -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000
#>
function Assert-AzCliSubscriptionAccessible {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $SubscriptionId
    )

    $state = Get-AzCliSubscriptionAccessState $SubscriptionId

    if (-not $state.logged_in) {
        throw 'Not logged in to az CLI. Run: az login'
    }
    if (-not $state.accessible) {
        $detail = if ($state.detail) {
            " az reported: $($state.detail)"
        }
        else {
            ''
        }
        throw (
            "Current az CLI login cannot access subscription '$SubscriptionId'. " +
            'Check the subscription id is correct and that your signed-in identity has a role on it. ' +
            'If it lives in another tenant, run: az login --tenant <tenantId>.' + $detail
        )
    }
}
