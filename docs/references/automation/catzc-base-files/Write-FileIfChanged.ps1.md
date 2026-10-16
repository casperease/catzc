---
catzc:
  immutable:
    with_body_sha: "086315865188"
    path: docs/references/automation/catzc-base-files/Write-FileIfChanged.ps1.md
    folder: docs/references/automation/catzc-base-files
    name: write-file-if-changed-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Files/Write-FileIfChanged.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[System.IO.File]::Delete($Path)`, written with `#`.

```text
Delete-then-write: an in-place write through a linked target would tunnel the composed content
into the link's source of truth; deleting first severs any link, so the write is always a fresh,
independent file.
```
