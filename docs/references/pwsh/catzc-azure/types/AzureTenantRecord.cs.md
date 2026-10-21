# pwsh/Catzc.Azure/types/AzureTenantRecord.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One `tenants` entry of configs/azure.yml ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): an Entra tenant
keyed by name. The config mirror (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); the resolved identity
node is Tenant. AzureConfig builds one per entry and collects its violations with the file's.

Shape: the name is a lower-snake_case identifier, `id` is a GUID, and no other key.
```
