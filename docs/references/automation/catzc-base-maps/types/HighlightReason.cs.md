# docs/references/automation/catzc-base-maps/types/HighlightReason.cs.md

`automation/Catzc.Base.Maps/types/HighlightReason.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Why a highlight lights a file, or a cell with no file: the file, the step that tied it to the request (a
MapPlacement basis, "path" for a requested file, "pin" for a reviewed pin of configs/maps.yml), the requested citation
that covers it, and the citation sites the request covers (where the file, or its owner's or globset's files, cite
it). An adr-file reason names the requested ADR's own file and has no site. A file lit only by comment sites is a
passing mention (Mention), so a reader can tell a lit file's subject from a mention. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
