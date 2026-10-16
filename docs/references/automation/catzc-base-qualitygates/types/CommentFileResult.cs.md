---
catzc:
  immutable:
    with_body_sha: bd33f2160b25
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/CommentFileResult.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: comment-file-result-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#9
---

# automation/Catzc.Base.QualityGates/types/CommentFileResult.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
What CommentEngine.Export decided for one file: the file's new text and its page's new text (each null when
nothing changes), and the blocks it moved. The engine never writes; the caller does
([ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)).
```
