---
catzc:
  immutable:
    with_body_sha: cad79f0bad20
    path: docs/references/automation/catzc-base-maps/types/MapCell.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: map-cell-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{1,3,6}
---

# automation/Catzc.Base.Maps/types/MapCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One cell of the world map: a track (the row) crossed with a file language (the column), and how many tracked files
sit in it ([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
[ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). A cell breaks "one tech-stack per track"
([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)) when it holds a live file whose file
language the track does not declare; WorldMapBuilder decides that per file (MapPlacement.StackViolation) and the
cell carries the result. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
