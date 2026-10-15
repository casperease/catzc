---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/WorldMapGridLayout.cs.md
    kind: comment-page
    body_sha: "0a42f8562447"
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#7
      - ADR-DSGN-TRACK#8
    links: []
---

# automation/Catzc.Base.Maps/types/WorldMapGridLayout.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Where the grid page of the world map puts things: the title, the legend band, the row headers (the tracks, then the
root files), the column headers (the file languages, then the unlisted files) and every cell
([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7),
[ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)). The page size comes from MapsLimits; the row
header is as wide as its longest printed label (within a third of the grid), and the columns share the rest evenly.
The column-header band holds the column axis on one line and the file-language names on two, so a name that wraps
leaves every column the same height.
Coordinates are PDF user space: the origin at the bottom-left, in points; row 0 is the top row. WorldMapPdf draws the
grid page from one of these, and the tests check its positions. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
