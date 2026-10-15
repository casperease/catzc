---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md
    kind: comment-page
    body_sha: bdf2f9e779c9
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/FileCarrier.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The properties are snake_case because they mirror the YAML keys; FileCarriersConfig validates an entry and builds one.
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```
