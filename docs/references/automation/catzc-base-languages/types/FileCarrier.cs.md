---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/types/FileCarrier.cs.md
    folder: docs/references/automation/catzc-base-languages/types
    name: file-carrier-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "62438d34031c"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Languages/types/FileCarrier.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The properties are snake_case because they mirror the YAML keys; FileCarriersConfig validates an entry and builds one.
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
[ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
```
