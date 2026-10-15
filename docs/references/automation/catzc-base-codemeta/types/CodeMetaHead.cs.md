---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/types/CodeMetaHead.cs.md
    kind: comment-page
    body_sha: "08ce3ebf58f7"
    adrs:
      - ADR-REPO-CODEMETA#1
      - ADR-REPO-FILEMETA#6
    links: []
---

# automation/Catzc.Base.CodeMeta/types/CodeMetaHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched.
[ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1),
[ADR-REPO-FILEMETA#6](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta6)
```
