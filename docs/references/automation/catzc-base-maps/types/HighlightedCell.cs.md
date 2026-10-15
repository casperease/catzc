# docs/references/automation/catzc-base-maps/types/HighlightedCell.cs.md

`automation/Catzc.Base.Maps/types/HighlightedCell.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
One lit cell of a world-map highlight: the cell (a track and a file language), the files in it that the request
lit, the steps that lit it (a MapPlacement basis, "path" for a requested file, "pin" for a reviewed pin of
configs/maps.yml), and why each lights it (Reasons; Touched when all are passing mentions). A result type, so the
properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
