---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/MapCell.cs.md
    kind: comment-page
    body_sha: b4bf71a3356a
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#3
      - ADR-DSGN-TRACK#6
    links: []
---

# automation/Catzc.Base.Maps/types/MapCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
One cell of the world map: a track (the row) crossed with a file language (the column), and how many tracked files
sit in it ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
[ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). A cell breaks "one tech-stack per track"
([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)) when it holds a live file whose file
language the track does not declare; WorldMapBuilder decides that per file (MapPlacement.StackViolation) and the
cell carries the result. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
