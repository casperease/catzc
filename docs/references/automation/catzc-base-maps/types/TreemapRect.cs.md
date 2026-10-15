---
catzc:
  derived:
    path: docs/references/automation/catzc-base-maps/types/TreemapRect.cs.md
    kind: reference
    body_sha: "3f9def9298ba"
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Maps/types/TreemapRect.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
One rectangle of a SquarifiedTreemap layout: the item it stands for (its key and weight) and where it sits, in PDF
user space (x and y are the bottom-left corner, in points). A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
