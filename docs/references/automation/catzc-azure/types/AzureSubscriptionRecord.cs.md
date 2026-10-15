# docs/references/automation/catzc-azure/types/AzureSubscriptionRecord.cs.md

`automation/Catzc.Azure/types/AzureSubscriptionRecord.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One `subscriptions` entry of configs/azure.yml ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): an Azure
subscription keyed by name, the tenant that owns it, the environments it serves, and — for a customer
subscription — the raw customer token. The config mirror (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); the resolved identity
node is AzureSubscription (with the customer normalized to its canonical key). AzureConfig builds one per entry
and collects its violations with the file's (the tenant/environment references and the cross-record rules are
AzureConfig's).

Shape: the name is a lower-snake_case identifier; `id` is a GUID; `tenant` is required; `environments` is a
required, non-empty list; `customer` is optional and NOT resolved here — it names a customer.yml customer by key
or shortcode, enforced by an integrity test and at runtime
([ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3)); no other key.
```
