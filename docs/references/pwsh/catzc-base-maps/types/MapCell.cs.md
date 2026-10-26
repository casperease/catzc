# pwsh/Base.Maps/types/MapCell.cs

One cell of the world map: a track (the row) crossed with a file language (the column), and how many tracked files sit in it
([DDR-TRACK-TRACKISPLACEDCLUSTER](../../../../drs/design/tracks.md#rule-ddr-track-trackisplacedcluster),
[DDR-TRACK-FILELANGUAGE](../../../../drs/design/tracks.md#rule-ddr-track-filelanguage)).

## Stack violation

A cell breaks "one tech-stack per track" ([DDR-TRACK-ONETECHSTACK](../../../../drs/design/tracks.md#rule-ddr-track-onetechstack)) when it
holds a live file whose file language the track does not declare. `WorldMapBuilder` decides that per file (`MapPlacement.StackViolation`)
and the cell carries the result.

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
