<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure/Get-AzureCustomers.ps1
    name: get-azure-customers
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
    cites:
      - ADR-AZ-CUSTOMER
  config:
    synopsis: Returns the customer keys defined in configs/customer.yml.
    description: |-
      Reads the customer catalogue (customer.yml) via Get-Config and returns its keys — the readable customer
      names referenced by customer subscriptions in azure.yml. Returns an empty array when the catalogue is
      empty. Customer definitions were split out of azure.yml (see
      [ADR-AZ-CUSTOMER](/docs/adr/azure/azure-customer-model.md)).
    examples:
      - |-
        Get-AzureCustomers
        # -> apex, nova, flux, dusk, warp, volt
---
#>

function Get-AzureCustomers {
    param()

    $customer = Get-Config -Config customer
    @($customer.customers.Keys)
}
