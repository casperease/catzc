# docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md

`automation/Catzc.Azure/types/AzureTenantRecord.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One `tenants` entry of configs/azure.yml ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): an Entra tenant
keyed by name. The config mirror (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); the resolved identity
node is Tenant. AzureConfig builds one per entry and collects its violations with the file's.

Shape: the name is a lower-snake_case identifier, `id` is a GUID, and no other key.
```
