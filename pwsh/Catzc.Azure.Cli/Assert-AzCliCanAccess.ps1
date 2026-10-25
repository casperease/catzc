<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-cli/Assert-AzCliCanAccess.ps1.md"
  header: "generated"
---
#>

function Assert-AzCliCanAccess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [ArgumentCompleter({ (Get-Config -Config azure).subscriptions.Keys })]
        [ValidateScript({ $_ -in (Get-Config -Config azure).subscriptions.Keys })]
        [string] $Subscription
    )

    $subscriptionDescriptor = Get-AzureSubscription $Subscription
    Assert-AzCliSubscriptionAccessible -SubscriptionId $subscriptionDescriptor.id
}
