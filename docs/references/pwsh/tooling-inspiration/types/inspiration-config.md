# pwsh/Tooling.Inspiration/types/InspirationConfig.cs

The typed model of `configs/inspiration.yml`: an `inspirations` list of [InspirationEntry](inspiration-entry.md)
([ADR-REPO-INSPIRE](../../../../drs/repository/inspiration.md)). It mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Validation

Constructing an instance maps and validates the parsed YAML and collects every violation into one throw. The load-time rules:

- the mapping's only key is `inspirations`, or the file is empty;
- `inspirations` is a list of well-formed entries;
- every id is unique.

## Default

The sensible default, the one `eac` entry, is declared once here as `DefaultInspirations`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). An empty
file and an omitted or null `inspirations` key take it, so an empty file and a fresh checkout behave the same. An explicit empty list
declares no inspirations, so "no inspirations" is always a choice.

## Registration

The type is registered in `pwsh/Base.Config/configs/configs.yml`, so `Get-Config -Config inspiration` returns this model.
