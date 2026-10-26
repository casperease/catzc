# pwsh/Base.Reports/types/ReportsConfig.cs

The quality-gate report settings (`configs/reports.yml`): where a gate writes its report and how the files are named
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Defaults

Every key has a sensible default, so the file overrides only what differs; an empty file means the defaults:
`out/test-<subject>/<yyyyMMdd-HHmmss>/<subject>.md` plus `out/test-<subject>/latest.txt`. `{subject}` in a value is the gate's subject (a
kebab-case name such as `spelling`). The type mirrors the YAML mapping (snake_case keys,
[ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
