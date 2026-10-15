---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/CommentFormatResult.cs.md
    kind: comment-page
    body_sha: ccd36f863ee3
    adrs:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.QualityGates/types/CommentFormatResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
What CommentFormatter.Format decided for one file: the file's new text (null when nothing changes) and every
finding, fixed or not. The formatter never writes; the caller does
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
