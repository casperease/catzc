# pwsh/Azure/types/AzureSubscriptionRecord.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One `subscriptions` entry of configs/azure.yml ([ADR-AZ-DATAMOD](/docs/drs/azure/azure-data-model.md)): an Azure
subscription keyed by name, the tenant that owns it, the environments it serves, and — for a customer
subscription — the raw customer token. The config mirror (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); the resolved identity
node is AzureSubscription (with the customer normalized to its canonical key). AzureConfig builds one per entry
and collects its violations with the file's (the tenant/environment references and the cross-record rules are
AzureConfig's).

Shape: the name is a lower-snake_case identifier; `id` is a GUID; `tenant` is required; `environments` is a
required, non-empty list; `customer` is optional and NOT resolved here — it names a customer.yml customer by key
or shortcode, enforced by an integrity test and at runtime
([ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/drs/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload)); no other key.
```
