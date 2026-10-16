---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4a419dac15d2"
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$lines.RemoveRange($titleIndex, $subtitleIndex - $titleIndex + 1)`, written with `#`.

```text
The H1 takes the subtitle's text without its backticks; the subtitle and the blank lines around it go.
A blank line is put back when a body line followed the subtitle directly, so the heading and what follows stay apart.
```
