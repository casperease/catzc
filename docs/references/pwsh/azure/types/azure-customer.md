# pwsh/Azure/types/AzureCustomer.cs

One customer of the catalogue, `configs/customer.yml` ([ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md)). It mirrors a
`customers` entry with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)), and
`key` is the map key.

## fields

- `key` is the readable name: the customer segment of relaxed resource names and the name of the configuration subfolder.
- `shortcode` is the customer segment of the restricted `kv`, `storage` and `vm` patterns.
- `details` is optional free text.

## validation

Constructing an instance validates the entry and collects every violation into one `ArgumentException`. The key is 2 or more lowercase
alphanumeric characters with a leading letter, the shortcode is exactly 2 lowercase letters, and the entry carries no key besides
`shortcode` and `details`. The catalogue-wide rules, shortcode uniqueness and no key equal to any shortcode, belong to `CustomerConfig`.
