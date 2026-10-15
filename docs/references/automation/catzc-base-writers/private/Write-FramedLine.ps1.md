---
catzc:
  derived:
    path: docs/references/automation/catzc-base-writers/private/Write-FramedLine.ps1.md
    kind: comment-page
    body_sha: "72bd2ee0e354"
---

# automation/Catzc.Base.Writers/private/Write-FramedLine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$rendered = foreach ($s in $Segment) {`.

```text
A rule line takes the per-character gradient; a titled line takes the base colour (the profile
side-grades to Base). The text is pre-coloured here, so it passes through the chokepoint with no
-ForegroundColor of its own.
```
