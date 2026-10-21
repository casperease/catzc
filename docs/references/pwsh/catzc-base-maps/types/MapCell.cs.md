# pwsh/Catzc.Base.Maps/types/MapCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One cell of the world map: a track (the row) crossed with a file language (the column), and how many tracked files
sit in it ([DDR-TRACK-TRACKISPLACEDCLUSTER](/docs/drs/design/tracks.md#rule-ddr-track-trackisplacedcluster),
[DDR-TRACK-FILELANGUAGE](/docs/drs/design/tracks.md#rule-ddr-track-filelanguage)). A cell breaks "one tech-stack per track"
([DDR-TRACK-ONETECHSTACK](/docs/drs/design/tracks.md#rule-ddr-track-onetechstack)) when it holds a live file whose file
language the track does not declare; WorldMapBuilder decides that per file (MapPlacement.StackViolation) and the
cell carries the result. A result type, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
