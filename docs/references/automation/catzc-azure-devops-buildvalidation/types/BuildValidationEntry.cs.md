# docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationEntry.cs.md

`automation/Catzc.Azure.DevOps.BuildValidation/types/BuildValidationEntry.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One entry of configs/build-validation.yml's `validations` list: an ADO build-validation branch policy tied to a
DECLARED globset ([ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4)). Mirrors the
YAML mapping (snake_case keys, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
BuildValidationConfig builds one per entry and prefixes every violation with the entry's index.

Constructing an instance validates the entry, collecting every violation into one ArgumentException: only the
keys globset (required, non-empty), pipeline and display_name (non-empty when present) and blocking (a
boolean when present). Globset existence is deliberately NOT checked here — that read would couple every
config load to the globs registry; it is enforced at runtime (Get-GlobSet throws) and by an integrity test
(the [ADR-AZ-CUSTOMER#3](/docs/adr/azure/azure-customer-model.md#rule-adr-az-customer3) pattern).
```

## comment:2

Above `public string pipeline { get; }`.

```text
The pipeline the policy runs. Null when absent: the consumer falls back to the globset's `pipeline:`
annotation in globs.yml.
```
