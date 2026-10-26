<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Test-AzCliIsConnected.ps1.md"
  header: "generated"
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
