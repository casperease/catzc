<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Azure/Get-AzureCustomers.ps1
    name: get-azure-customers
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
    cites:
      - ADR-AZ-CUSTOMER
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
