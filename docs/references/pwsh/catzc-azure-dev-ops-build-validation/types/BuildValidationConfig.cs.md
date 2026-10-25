# pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class BuildValidationConfig : Catzc.Base.Objects.DictionaryRecord`, written with `//`.

```text
The build-validation branch policies (configs/build-validation.yml): the local config that ties ADO
build-validation policies on one branch to globsets — the server-side pre-commit half of a unit's CI binding
([FDR-CD-TYPE-PRECOMMITBUDGET](/docs/drs/flow/pipeline-types.md#rule-fdr-cd-type-precommitbudget)). Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.BuildValidation.BuildValidationConfig), so
Get-Config -Config build-validation returns this typed record. Mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)); globset names live in
VALUES because they are kebab-case.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the top-level keys branch and validations, both required;
  - branch is non-empty (e.g. main);
  - validations is a non-empty LIST of well-formed BuildValidationEntry mappings, one per globset (unique).
```
