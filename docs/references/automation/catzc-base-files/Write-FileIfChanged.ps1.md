---
catzc:
  derived:
    path: docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md
    kind: comment-page
    body_sha: cfae784bf003
---

# automation/Catzc.Base.Files/Write-FileIfChanged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `[System.IO.File]::Delete($Path)`.

```text
Delete-then-write: an in-place write through a linked target would tunnel the composed content
into the link's source of truth; deleting first severs any link, so the write is always a fresh,
independent file.
```
