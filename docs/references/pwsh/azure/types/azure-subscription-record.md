# pwsh/Azure/types/AzureSubscriptionRecord.cs

One `subscriptions` entry of `configs/azure.yml` ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)): an Azure subscription keyed
by name, the tenant that owns it, the environments it serves and, for a customer subscription, the raw customer token. It is the config
mirror, with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
resolved identity node is `AzureSubscription`, with the customer normalized to its canonical key.

`AzureConfig` builds one record per entry and collects its violations with the file's. The tenant and environment references and the
cross-record rules are `AzureConfig`'s.

## shape

- The name is a lower-snake_case identifier, `id` is a GUID, and `tenant` is required.
- `environments` is a required, non-empty list.
- `customer` is optional. It names a `customer.yml` customer by key or shortcode and is not resolved here: an integrity test and the runtime
  check enforce it
  ([ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)).
- No other key is allowed.
