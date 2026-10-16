---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/types/CodeMetaHead.cs.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d566eadc0aa6
    adrs:
      - ADR-REPO-CODEMETA#1
      - ADR-REPO-FILEMETA#6
---

# automation/Catzc.Base.CodeMeta/types/CodeMetaHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched.
[ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1),
[ADR-REPO-FILEMETA#6](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta6)
```
