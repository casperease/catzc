<#
---
catzc:
  immutable:
    with_body_sha: e494e83e50d7
  edges:
    test: pwsh/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
    docs: "[Get-AzureCustomers.ps1.md](../../docs/references/pwsh/catzc-azure/Get-AzureCustomers.ps1.md)"
    cites:
      - ADR-AZ-CUSTOMER
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
