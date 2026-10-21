<#
---
catzc:
  immutable:
    with_body_sha: "2b7eaa94fc59"
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureSubscriptionCustomer.Tests.ps1
    docs: "[Get-AzureSubscriptionCustomer.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureSubscriptionCustomer.ps1.md)"
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
