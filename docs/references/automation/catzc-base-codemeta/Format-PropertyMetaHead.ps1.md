---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/Format-PropertyMetaHead.ps1.md
    kind: comment-page
    body_sha: c970746ce88b
    adrs:
      - ADR-REPO-FILEMETA#8
---

# automation/Catzc.Base.CodeMeta/Format-PropertyMetaHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The same facts always give the same bytes, so a second run changes no file (ADR-REPO-FILEMETA#8). A text that is no JSON object, or
whose property holds something else, comes back as it was.
```
