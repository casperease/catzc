---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/TreemapRect.cs.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "074f8a140c4b"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/TreemapRect.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One rectangle of a SquarifiedTreemap layout: the item it stands for (its key and weight) and where it sits, in PDF
user space (x and y are the bottom-left corner, in points). A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
