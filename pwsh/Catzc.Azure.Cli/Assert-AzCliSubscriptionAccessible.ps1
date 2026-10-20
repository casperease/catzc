<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1
    name: assert-az-cli-subscription-accessible
    filetype: ps1
    role: function
    subkind: assert
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Cli
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliSubscriptionAccessible.Tests.ps1
    docs: "[Assert-AzCliSubscriptionAccessible.ps1.md](docs/references/pwsh/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md)"
    cites:
      - ADR-AUTO-FAILFAST
      - ADR-AZ-CLI-AZBYDEFAULT
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
