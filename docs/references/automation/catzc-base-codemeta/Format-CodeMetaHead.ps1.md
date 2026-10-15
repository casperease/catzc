---
catzc:
  derived:
    path: docs/references/automation/catzc-base-codemeta/Format-CodeMetaHead.ps1.md
    kind: comment-page
    body_sha: c4f3beb58c52
    adrs:
      - ADR-REPO-FILEMETA#3
    links: []
---

# automation/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The same facts always give the same bytes, so a second run changes no file and a formatter never undoes the head.
[ADR-REPO-FILEMETA#3](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta3)
```
