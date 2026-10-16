---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/HighlightReason.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: df56639377f4
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/HighlightReason.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Why a highlight lights a file, or a cell with no file: the file, the step that tied it to the request (a
MapPlacement basis, "path" for a requested file, "pin" for a reviewed pin of configs/maps.yml), the requested citation
that covers it, and the citation sites the request covers (where the file, or its owner's or globset's files, cite
it). An adr-file reason names the requested ADR's own file and has no site. A file lit only by comment sites is a
passing mention (Mention), so a reader can tell a lit file's subject from a mention. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
