<#
---
catzc:
  immutable:
    with_body_sha: fdafe152395a
  edges:
    test: pwsh/Catzc.Azure.Cli/tests/Test-AzCliIsConnected.Tests.ps1
    docs: "[Test-AzCliIsConnected.ps1.md](docs/references/pwsh/catzc-azure-cli/Test-AzCliIsConnected.ps1.md)"
---
#>

function Test-AzCliIsConnected {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription

    Test-AzCliConnected `
        -SubscriptionId $subscriptionDescriptor.id `
        -TenantId $subscriptionDescriptor.tenant.id
}
