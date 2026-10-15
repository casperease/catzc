---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Format-GeneratedFileHead.ps1.md
    kind: comment-page
    body_sha: a37ea939b460
    adrs:
      - ADR-REPO-FILEMETA#7
---

# automation/Catzc.Base.Languages/Format-GeneratedFileHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The head is the one unified form of ADR-REPO-FILEMETA#7: kind generated-from-source, and the generator and the source when the file has
them. The carrier is named by id, or found from the file's language when no id is given.
```
