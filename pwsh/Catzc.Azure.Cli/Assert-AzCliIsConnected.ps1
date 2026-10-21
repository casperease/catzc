<#
---
catzc:
  immutable:
    with_body_sha: e46f91e9da1c
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Assert-AzCliIsConnected.Tests.ps1
    docs: "[Assert-AzCliIsConnected.ps1.md](../../docs/references/pwsh/catzc-azure-cli/Assert-AzCliIsConnected.ps1.md)"
    cites:
      - ADR-AZ-DATAMOD
---
#>

function Assert-AzCliIsConnected {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription

    $state = Get-AzCliConnectionState `
        -SubscriptionId $subscriptionDescriptor.id `
        -TenantId $subscriptionDescriptor.tenant.id

    if (-not $state.logged_in) {
        throw "Not logged in to az CLI. Run: az login --tenant $($state.expected_tenant)"
    }
    if (-not $state.connected) {
        throw (
            "az CLI is logged into the wrong context for subscription '$Subscription'. " +
            "Expected tenant=$($state.expected_tenant) sub=$($state.expected_subscription); " +
            "got tenant=$($state.actual_tenant) sub=$($state.actual_subscription). " +
            "Run: az login --tenant $($state.expected_tenant); az account set --subscription $($state.expected_subscription)"
        )
    }
}
