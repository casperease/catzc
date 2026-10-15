---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Update-AdrCitation.ps1.md
    kind: comment-page
    body_sha: "74049042611a"
---

# automation/Catzc.Base.Docs/Update-AdrCitation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$bytes = [System.IO.File]::ReadAllBytes($file)`.

```text
Decode strictly, so a file that is not UTF-8 fails here instead of being re-encoded; the byte order mark is
kept aside and written back as it was.
```
