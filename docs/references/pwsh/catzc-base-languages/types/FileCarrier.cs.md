# pwsh/Base.Languages/types/FileCarrier.cs

One entry of `file-carriers.yml`: where a file class keeps its meta block, or why it has none. The properties are snake_case because they
mirror the YAML keys; `FileCarriersConfig` validates an entry and builds one
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml),
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
