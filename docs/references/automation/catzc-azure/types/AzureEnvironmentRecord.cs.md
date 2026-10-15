# docs/references/automation/catzc-azure/types/AzureEnvironmentRecord.cs.md

`automation/Catzc.Azure/types/AzureEnvironmentRecord.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One `environments` entry of configs/azure.yml ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md),
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)): a deployment environment keyed by its readable name.
The config mirror (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8));
the resolved identity node is AzureEnvironment. AzureConfig builds one per entry and collects its violations
with the file's (shortcode uniqueness is AzureConfig's).

Shape: the name (the deploy handle, the config-file name, and the relaxed env-segment) is 2+ lowercase
alphanumeric with a leading letter; `shortcode` is 2 lowercase letters (the tight-pattern env-segment); `region`
is non-empty; `region_code` is 3 lowercase letters; `per_subscription`, when present, is a boolean; no other
key.
```
