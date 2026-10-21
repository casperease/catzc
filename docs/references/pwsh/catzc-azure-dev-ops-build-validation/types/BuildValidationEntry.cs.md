# pwsh/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One entry of configs/build-validation.yml's `validations` list: an ADO build-validation branch policy tied to a
DECLARED globset ([ADR-FLOW-CD-TYPE-PRECOMMITBUDGET](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type-precommitbudget)). Mirrors the
YAML mapping (snake_case keys, [ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
BuildValidationConfig builds one per entry and prefixes every violation with the entry's index.

Constructing an instance validates the entry, collecting every violation into one ArgumentException: only the
keys globset (required, non-empty), pipeline and display_name (non-empty when present) and blocking (a
boolean when present). Globset existence is deliberately NOT checked here — that read would couple every
config load to the globs registry; it is enforced at runtime (Get-GlobSet throws) and by an integrity test
(the [ADR-AZ-CUSTOMER-REFERENCENOTVALIDATEDONLOAD](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer-referencenotvalidatedonload) pattern).
```

## comment:2

Above `public string pipeline { get; }`, written with `//`.

```text
The pipeline the policy runs. Null when absent: the consumer falls back to the globset's `pipeline:`
annotation in globs.yml.
```
