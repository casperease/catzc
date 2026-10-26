# pwsh/Azure/types/CustomerConfig.cs

The typed record of the customer catalogue, `configs/customer.yml` ([ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)): the
customers this repository can deploy for. Which of them are enabled is the `have_customers` variant, not this file.
`Get-Config -Config customer` returns this record, because it is registered in `Catzc.Base.Config/configs/configs.yml` as
`Catzc.Azure.CustomerConfig`. It mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## validation

Constructing an instance validates the file and collects every violation into one `ArgumentException`:

- The top-level key `customers` is required, an empty map is allowed, and no other key is allowed.
- Every entry is a well-formed `AzureCustomer`, with a valid key and shortcode.
- Shortcodes are unique.
- No key equals any shortcode. A subscription's `customer` field may name a customer by key or by shortcode, so a collision would make the
  reference ambiguous ([ADR-AZ-CUSTOMER-TWOBINDINGS](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-twobindings)).

## independence from azure.yml

The type is self-contained and does not read `azure.yml`. A subscription references a customer here, so `azure.yml` depends on
`customer.yml` and never the reverse
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).

## customers property

`customers` is the catalogue, keyed by customer key in file order. A dictionary enumerates in insertion order when nothing is removed, and
this one is never mutated after construction.
