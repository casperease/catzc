# pwsh/Catzc.Base.Maps/types/MapCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One cell of the world map: a track (the row) crossed with a file language (the column), and how many tracked files
sit in it ([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](/docs/adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster),
[ADR-DSGN-TRACK-FILELANGUAGE](/docs/adr/design/tracks.md#rule-adr-dsgn-track-filelanguage)). A cell breaks "one tech-stack per track"
([ADR-DSGN-TRACK-ONETECHSTACK](/docs/adr/design/tracks.md#rule-adr-dsgn-track-onetechstack)) when it holds a live file whose file
language the track does not declare; WorldMapBuilder decides that per file (MapPlacement.StackViolation) and the
cell carries the result. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-snakecasemirrorsyaml)).
```
