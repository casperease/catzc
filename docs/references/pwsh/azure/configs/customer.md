# pwsh/Azure/configs/customer.yml

The customer catalogue: the customers this repository can deploy for, split out of `azure.yml`
([ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)). `Get-Config -Config customer` loads it and the `CustomerConfig` type
validates it.

## binding

A subscription in `azure.yml` binds to a customer by naming it in its `customer` field, by the readable key (apex) or by the 2-character
shortcode (ap). Both resolve to the same customer. The key is the customer segment of relaxed resource names and the name of the
configuration subfolder. The unique 2-character `shortcode` is the customer segment of the restricted `kv`, `storage` and `vm` patterns, the
same name and shortcode split as environments ([ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md)). `details` is a free-text
label.

## enabled customers

This file is only the catalogue of who the customers are. Which of them are enabled for deployment is the `have_customers` variant in
`variants.yml`.

## optional file

A repository with no customers omits the file, and `Get-AzureCustomers` then returns an empty array.
