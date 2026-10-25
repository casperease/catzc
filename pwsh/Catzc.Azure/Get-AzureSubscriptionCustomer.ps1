<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure/Get-AzureSubscriptionCustomer.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AzureSubscriptionCustomer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        $Subscription
    )

    if ($Subscription.Contains('customer')) {
        return $Subscription.customer
    }
    ''
}
