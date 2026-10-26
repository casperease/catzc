# pwsh/Base.Maps/types/WorldMapGridLayout.cs

Where the grid page of the world map puts things: the title, the legend band, the row headers (the tracks, then the root files), the column
headers (the file languages, then the unlisted files) and every cell
([DDR-TRACK-ROOTFILE](../../../../drs/design/tracks.md#rule-ddr-track-rootfile),
[DDR-TRACK-UNLISTEDFILE](../../../../drs/design/tracks.md#rule-ddr-track-unlistedfile)). `WorldMapPdf` draws the grid page from one of
these, and the tests check its positions.

## Geometry

The page size comes from `MapsLimits`. The row header is as wide as its longest printed label, within a third of the grid, and the columns
share the rest evenly. The column-header band holds the column axis on one line and the file-language names on two, so a name that wraps
leaves every column the same height. Coordinates are PDF user space: the origin at the bottom-left, in points; row 0 is the top row.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
