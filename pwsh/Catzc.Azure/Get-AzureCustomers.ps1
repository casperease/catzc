<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure/Get-AzureCustomers.ps1
    name: get-azure-customers
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
    test: pwsh/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
    docs: "[Get-AzureCustomers.ps1.md](docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md)"
    cites:
      - ADR-AZ-CUSTOMER
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
