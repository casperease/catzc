# pwsh/Catzc.Base.Maps/types/ValueChainReason.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Why a value-chain highlight lights a cell for one ADR: the requested citation, the ADR code, its ADR domain and that
domain's row of the value-chain stack ([DDR-TRACK-VALUECHAINSTACK](/docs/adr/design/tracks.md#rule-ddr-track-valuechainstack)), the
value-chain concern of the lit cell, and the ADR's value-chain concerns with the ADR domain's default
([DDR-TRACK-VALUECHAINCONCERN](/docs/adr/design/tracks.md#rule-ddr-track-valuechainconcern)): Override is true when the ADR declares its
own concerns instead of the default. A result type, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
