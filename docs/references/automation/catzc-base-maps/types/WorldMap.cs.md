---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/WorldMap.cs.md
    kind: reference
    body_sha: aa1c0b149d21
    adrs:
      - ADR-DSGN-TRACK#1
      - ADR-DSGN-TRACK#6
      - ADR-THES-ONETRUTH#3
---

# automation/Catzc.Base.Maps/types/WorldMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The world map: the tracks (rows) crossed with the file languages (columns), every cell of that grid with its file
count, and the placement of every tracked file in exactly one cell
([ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1),
[ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). Two buckets close the grid so no file is
left out: the NoTrack row holds the files under no track (the repository root's own files, and out/), and the
NoFileLanguage column holds the files no file language names (no extension, or an extension no entry lists). The
order is deterministic: rows and columns in ordinal order with the bucket last, cells row by row, placements by path.
WorldMapBuilder builds one; Get-WorldMap returns it, and ToJson is its data form
([ADR-THES-ONETRUTH#3](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).
```
