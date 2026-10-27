# pwsh/Base.Maps/types/ValueChainCell.cs

One cell of the value-chain map: a row of the value-chain stack crossed with a value-chain concern, and the ADRs that sit in it
([ADR-REPO-VALUECHAIN-MAP](../../../../drs/repository/drs-value-chain.md#rule-adr-repo-valuechain-map),
[DDR-TRACK-CELL](../../../../drs/design/tracks.md#rule-ddr-track-cell)).

## Adrs

`Adrs` holds the ADR codes of the cell. On the map it holds every ADR of the cell in `drs.yml` order, and on a highlight the requested ADRs
that light it, in request order. It is empty for an empty cell of the grid.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
