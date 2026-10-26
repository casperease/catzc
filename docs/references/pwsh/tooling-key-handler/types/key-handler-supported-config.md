# pwsh/Tooling.KeyHandler/types/KeyHandlerSupportedConfig.cs

The typed model of `configs/key-handler-supported.yml`: the PSReadLine functions supported on Linux, the allow-list
`Import-PsReadLineKeyHandlerSet` filters the captured bindings against, so a Windows-only function is skipped rather than throwing.

## Load-time rules

- The mapping's only key is `functions`.
- `functions` is a non-empty list of non-blank function names.

Constructing an instance maps and validates the parsed YAML and collects every violation into one throw. The type mirrors the YAML mapping
with snake_case keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Registration

The type is registered in `pwsh/Base.Config/configs/configs.yml`, so `Get-Config -Config key-handler-supported` returns this model.
