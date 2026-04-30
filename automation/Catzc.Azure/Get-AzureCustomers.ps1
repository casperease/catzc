<#
.SYNOPSIS
    Returns the customer keys defined in configs/customer.yml.
.DESCRIPTION
    Reads the customer catalogue (customer.yml) via Get-Config and returns its keys — the readable customer
    names referenced by customer subscriptions in azure.yml. Returns an empty array when the catalogue is
    empty. Customer definitions were split out of azure.yml (see docs/adr/azure/customer-model.md).
.EXAMPLE
    Get-AzureCustomers
    # -> apex, nova, flux, dusk, warp, volt
#>
function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
