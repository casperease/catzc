---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentFileResult.cs.md
    kind: reference
    body_sha: "2ef1b4a9c8fc"
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.QualityGates/types/CommentFileResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
What CommentEngine.Export decided for one file: the file's new text and its page's new text (each null when
nothing changes), and the blocks it moved. The engine never writes; the caller does
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
