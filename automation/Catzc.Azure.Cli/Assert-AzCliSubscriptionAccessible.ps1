<#
.SYNOPSIS
    Asserts the current az CLI login can reach a given subscription.
.DESCRIPTION
    The throwing companion to Test-AzCliSubscriptionAccessible. Throws a remediation-bearing error when
    az is not logged in, or is logged in but cannot reach the subscription passed by argument. Drop it
    at the top of any function that is about to call az against a subscription — whether that
    subscription is the active one or supplied via `--subscription <id>` — to fail fast with a clear
    message instead of deep inside the later call.

    The check is a real, read-only ARM call (see Get-AzCliSubscriptionAccessState), so a pass proves
    the later call will actually reach ARM, not merely that the subscription is in the local profile.
    The generic, azure.yml-free primitive. Both Assert/Test share Get-AzCliSubscriptionAccessState.
    See docs/adr/automation/powershell/prefer-az-cli.md#rule-adr-auto-azcli1 and
    docs/adr/automation/fail-fast-with-asserts.md.
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
