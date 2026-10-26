# pwsh/Tooling.KeyHandler/types/KeyHandlerBinding.cs

One captured PSReadLine key binding of `configs/key-handler-bindings.yml`, a `- key: <chord>` and `function: <name>` pair that
`Save-PsReadLineKeyHandlerSet` writes and `Import-PsReadLineKeyHandlerSet` replays.

## Validation

Constructing one maps and validates the entry: a mapping carrying a non-empty `key` and `function`, the only two keys the capture writes.
Every violation is reported in one throw, prefixed with the entry's position. The type mirrors the YAML mapping with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
