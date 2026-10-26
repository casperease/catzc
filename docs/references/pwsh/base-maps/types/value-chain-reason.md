# pwsh/Base.Maps/types/ValueChainReason.cs

Why a value-chain highlight lights a cell for one ADR: the requested citation, the ADR code, its ADR domain and that domain's row of the
value-chain stack ([DDR-TRACK-VALUECHAINSTACK](../../../../drs/design/tracks.md#rule-ddr-track-valuechainstack)).

## Concerns

It also holds the value-chain concern of the lit cell, and the ADR's value-chain concerns with the ADR domain's default
([DDR-TRACK-VALUECHAINCONCERN](../../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)). `Override` is true when the ADR declares
its own concerns instead of the default.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
