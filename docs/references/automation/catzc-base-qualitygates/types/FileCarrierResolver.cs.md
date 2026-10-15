---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/FileCarrierResolver.cs.md
    kind: comment-page
    body_sha: "5ba698e1e81e"
    adrs:
      - ADR-REPO-FILEMETA#5
    links: []
---

# automation/Catzc.Base.QualityGates/types/FileCarrierResolver.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Finds the carrier entry of a repository path, with every glob compiled once, so a scan of all tracked files stays cheap.
[ADR-REPO-FILEMETA#5](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta5)
```
