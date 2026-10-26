# pwsh/Base.Drs/types/DrsNeutralityCheck.cs

The settings of the engine-neutrality check (`configs/drs-checks.yml`, `engine_neutrality`), read by `Test-DrsEngineNeutrality`: the rule
summaries of the listed `drs.yml` domains carry no engine-specific syntax
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)). `DrsChecksConfig`
builds and validates it.

## Keys

It mirrors the YAML mapping, so its properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

- **`mode`** — `report` or `gate`. The default is `CheckMode`'s default, `gate`.
- **`domains`** — the `drs.yml` domains whose rule summaries are checked. The default is none.
- **`tokens`** — a map of token name (kebab-case) to a case-sensitive .NET regular expression. The default is none.

## Why it is shaped so

Whether each domain is declared in `drs.yml` is the check's own finding, not a load-time rule, because this type reads no other config.
