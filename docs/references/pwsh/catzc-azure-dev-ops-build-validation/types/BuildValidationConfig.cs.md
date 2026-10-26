# pwsh/Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs

The typed record for `build-validation.yml`, the local config that ties build-validation policies on one branch to globsets: the
server-side pre-commit half of a unit's CI binding
([FDR-CD-TYPE-PRECOMMITBUDGET](../../../../drs/flow/pipeline-types.md#rule-fdr-cd-type-precommitbudget)). It is registered in
`Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config build-validation` returns it. Its properties mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); a
globset name lives in a value, because kebab case cannot be a key.

## Validation

Constructing the record checks the file and gathers every violation into one `ArgumentException`:

- only the top-level keys `branch` and `validations` are allowed, and both are required;
- `branch` is not empty;
- `validations` is a non-empty list of well-formed `BuildValidationEntry` mappings, one per globset, with no globset twice.
