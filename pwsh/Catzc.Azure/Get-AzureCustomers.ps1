<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md"
  header: "generated"
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
