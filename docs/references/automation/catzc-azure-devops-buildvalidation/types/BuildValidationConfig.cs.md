# docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md

`automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The build-validation branch policies (configs/build-validation.yml): the local config that ties ADO
build-validation policies on one branch to globsets — the server-side pre-commit half of a unit's CI binding
([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.BuildValidation.BuildValidationConfig), so
Get-Config -Config build-validation returns this typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); globset names live in
VALUES because they are kebab-case.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the top-level keys branch and validations, both required;
  - branch is non-empty (e.g. main);
  - validations is a non-empty LIST of well-formed BuildValidationEntry mappings, one per globset (unique).
```
