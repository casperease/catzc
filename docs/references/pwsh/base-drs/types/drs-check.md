# pwsh/Base.Drs/types/DrsCheck.cs

The settings of one DRS check in `configs/drs-checks.yml` that needs nothing beyond its mode: the citation graph of the rule summaries,
checked by `Test-DrsRegistry`. `DrsChecksConfig` builds and validates it.

## Keys

It mirrors the YAML mapping, so its property is snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

- **`mode`** — `report` or `gate`. The default is `CheckMode`'s default, `gate`.
