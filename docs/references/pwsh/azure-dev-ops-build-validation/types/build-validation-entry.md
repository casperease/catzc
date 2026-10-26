# pwsh/Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs

The typed record for one entry of the `validations` list in `build-validation.yml`: a build-validation branch policy tied to a declared
globset ([FDR-TYPE-PRECOMMITBUDGET](../../../../drs/flow/pipeline-types.md#rule-fdr-type-precommitbudget)). Its properties mirror the YAML
keys ([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`BuildValidationConfig` builds one per entry and prefixes every violation with the entry's index.

## Validation

Constructing the record checks the entry and gathers every violation into one `ArgumentException`: only the keys `globset` (required, not
empty), `pipeline` and `display_name` (not empty when present) and `blocking` (a boolean when present) are allowed.

A globset's existence is deliberately not checked here, because that read would couple every config load to the globs registry. It is
enforced at run time, where `Get-GlobSet` throws, and by an integrity test
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).

## Properties

- **`pipeline`** — the pipeline the policy runs. Null when absent, and the consumer then falls back to the globset's `pipeline:` annotation
  in `globs.yml`.
- **`blocking`** — whether the policy blocks the merge; true when absent.
- **`display_name`** — the policy display name. Null when absent, and the consumer defaults it to `Build validation - <globset>`.
