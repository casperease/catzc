# pwsh/Catzc.Base.Maps/types/WorldMap.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The world map: the tracks (rows) crossed with the file languages (columns), every cell of that grid with its file
count, and the placement of every tracked file in exactly one cell
([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](/docs/adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster),
[ADR-DSGN-TRACK-FILELANGUAGE](/docs/adr/design/tracks.md#rule-adr-dsgn-track-filelanguage)). Two buckets close the grid so no file is
left out: the NoTrack row holds the files under no track (the repository root's own files, and out/), and the
NoFileLanguage column holds the files no file language names (no extension, or an extension no entry lists). The
order is deterministic: rows and columns in ordinal order with the bucket last, cells row by row, placements by path.
WorldMapBuilder builds one; Get-WorldMap returns it, and ToJson is its data form
([ADR-THES-ONETRUTH-TRUTHISQUERYABLE](/docs/adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth-truthisqueryable)).
```
