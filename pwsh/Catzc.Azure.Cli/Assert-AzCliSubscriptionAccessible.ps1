<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md"
  warning: "Generated Header"
---
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
