<#
.SYNOPSIS
    Returns the customer keys defined in configs/customer.yml.
.DESCRIPTION
    Reads the customer catalogue (customer.yml) via Get-Config and returns its keys — the readable customer names...
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
