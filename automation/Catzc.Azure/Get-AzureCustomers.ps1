<#
---
catzc:
  derived:
    path: automation/Catzc.Azure/Get-AzureCustomers.ps1
    kind: function
    module: Catzc.Azure
    visibility: public
    adrs:
      - ADR-AZ-CUSTOMER
---
#>

<#
.SYNOPSIS
    Returns the customer keys defined in configs/customer.yml.
.DESCRIPTION
    An empty catalogue yields an empty array, never an error, so callers can loop without a guard.
    [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)
    [comment:1](/docs/references/automation/catzc-azure/Get-AzureCustomers.ps1.md#comment1)
.EXAMPLE
    Get-AzureCustomers
    # -> apex, nova, flux, dusk, warp, volt
#>
function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
