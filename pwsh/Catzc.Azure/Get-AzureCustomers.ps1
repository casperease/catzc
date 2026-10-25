<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
