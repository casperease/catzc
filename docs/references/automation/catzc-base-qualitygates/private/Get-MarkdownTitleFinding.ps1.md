---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md
    kind: comment-page
    body_sha: "994c90f7dde7"
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$lines.RemoveRange($titleIndex, $subtitleIndex - $titleIndex + 1)`.

```text
The H1 takes the subtitle's text without its backticks; the subtitle and the blank lines around it go.
A blank line is put back when a body line followed the subtitle directly, so the heading and what follows stay apart.
```
