<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure/Get-AzureSubscriptionCustomer.ps1
    name: get-azure-subscription-customer
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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
