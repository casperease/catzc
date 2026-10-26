# pwsh/Azure/types/AzureEnvironmentRecord.cs

One `environments` entry of `configs/azure.yml` ([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md),
[ADR-AZ-NAMING](../../../../drs/azure/azure-naming-standard.md)): a deployment environment keyed by its readable name. It is the config
mirror, with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)). The
resolved identity node is `AzureEnvironment`. `AzureConfig` builds one record per entry and collects its violations with the file's;
shortcode uniqueness is `AzureConfig`'s.

## shape

- The name is the deploy handle, the config-file name and the relaxed environment segment. It is 2 or more lowercase alphanumeric characters
  with a leading letter.
- `shortcode` is 2 lowercase letters, the environment segment of the tight patterns.
- `region` is non-empty, and `region_code` is 3 lowercase letters.
- `per_subscription`, when present, is a boolean.
- `staging_for`, when present, names another environment this one stages, the slot that is not yet active
  ([ADR-AZ-DATAMOD-STAGINGSLOT](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-stagingslot)). `AzureConfig` checks the
  target.
- No other key is allowed.
