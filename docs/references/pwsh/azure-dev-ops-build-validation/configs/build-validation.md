# pwsh/Azure.DevOps.BuildValidation/configs/build-validation.yml

The build-validation branch policies tied to globsets: the server-side pre-commit half of a unit's CI binding
([FDR-TYPE-PRECOMMITBUDGET](../../../../drs/flow/pipeline-types.md#rule-fdr-type-precommitbudget)). Each entry binds one declared globset's
native path projection ([FDR-GLOBS](../../../../drs/flow/durable-sha-globs.md)) as the policy's path filter and runs the entry's pipeline as
an Azure DevOps build validation on `branch`.

## Keys

- **`branch`** — the branch the policies guard.
- **`validations`** — a list of entries. A list, because globset names are kebab-case and snake_case key validation forbids hyphenated map
  keys. Each entry holds:
  - `globset` — required, a declared globset name;
  - `pipeline` — defaults to the globset's own `pipeline:` annotation in `globs.yml`;
  - `blocking` — defaults to true;
  - `display_name` — defaults to `Build validation - <globset>`.

## Loading and applying

`Get-Config -Config build-validation` loads the file and the `BuildValidationConfig` type validates its shape. `Sync-AdoBuildValidations`
and `Register-AdoBuildValidation` apply it to the server. A globset's existence is checked at run time, where `Get-GlobSet` throws on an
unknown name, and by an integrity test, never at load, so reading this config stays hermetic
([ADR-AZ-CUSTOMER-REFERENCEUNVALIDATED](../../../../drs/azure/azure-customer-model.md#rule-adr-az-customer-referenceunvalidated)).
