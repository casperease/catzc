---
catzc:
  immutable:
    with_body_sha: "4360f996ecaf"
    repo_status: locked
    path: docs/references/automation/catzc-base-maps/types/HighlightedCell.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: highlighted-cell-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/HighlightedCell.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One lit cell of a world-map highlight: the cell (a track and a file language), the files in it that the request
lit, the steps that lit it (a MapPlacement basis, "path" for a requested file, "pin" for a reviewed pin of
configs/maps.yml), and why each lights it (Reasons; Touched when all are passing mentions). A result type, so the
properties are PascalCase ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
