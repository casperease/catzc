# pwsh/Base.Drs/types/DrsNeutralityToken.cs

One forbidden token of the engine-neutrality check (`configs/drs-checks.yml`, `engine_neutrality.token_sets.<set>`): a kebab-case name and a
case-sensitive .NET regular expression that matches engine-specific syntax in a rule summary.

## Validation

It mirrors the YAML entry, so its properties are snake_case
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
`DrsNeutralityCheck` builds and validates it, and rejects a name that is not kebab-case and a pattern that does not compile.
