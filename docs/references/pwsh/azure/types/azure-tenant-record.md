# pwsh/Azure/types/AzureTenantRecord.cs

One `tenants` entry of `configs/azure.yml` ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)): an Entra tenant keyed by name. It
is the config mirror, with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
resolved identity node is `Tenant`. `AzureConfig` builds one record per entry and collects its violations with the file's.

## shape

The name is a lower-snake_case identifier, `id` is a GUID, and no other key is allowed.
