# pwsh/Catzc.Azure/Get-AzureCustomers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the customer keys defined in configs/customer.yml.

### description

Reads the customer catalogue (customer.yml) via Get-Config and returns its keys — the readable customer names referenced by customer
subscriptions in azure.yml. Returns an empty array when the catalogue is empty. Customer definitions were split out of azure.yml (see
[ADR-AZ-CUSTOMER](../../../adr/azure/azure-customer-model.md)).

### example 1

```powershell
Get-AzureCustomers
# -> apex, nova, flux, dusk, warp, volt
```
