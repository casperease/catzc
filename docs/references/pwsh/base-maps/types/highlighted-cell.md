# pwsh/Base.Maps/types/HighlightedCell.cs

One lit cell of a world-map highlight: the cell (a track and a file language), the files in it that the request lit, the steps that lit it
and why each file lights it.

## Fields

The steps are a `MapPlacement` basis, `path` for a requested file, or `pin` for a reviewed pin of `configs/maps.yml`. `Reasons` holds one
`HighlightReason` per lit file, and `Touched` is true when all of them are passing mentions.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
