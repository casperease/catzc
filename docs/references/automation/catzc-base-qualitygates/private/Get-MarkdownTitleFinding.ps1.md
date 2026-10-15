# docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The title is the first non-blank line after an optional YAML front-matter block; it must be an H1 that is not the
file's own repository path (the path is a derived meta fact, never the title). Only that line is read as the title,
so a `#` line in a later fenced code block never counts. Kind is Ok (an H1 that is a title), PathTitle (the H1 is
the path and one backticked line follows), Untitled (the H1 is the path and nothing titles it), or Missing (the first
line is not an H1). A PathTitle is repaired: the H1 takes the backticked line's text without its backticks and the
line goes, so no authored wording is lost. Untitled and Missing have no repair, since nothing can invent a title: a
person writes it. Fixed is the corrected file text, keeping the file's own line endings; it equals the input for every
Kind but PathTitle.
```

## comment:2

Above `$lines.RemoveRange($titleIndex, $subtitleIndex - $titleIndex + 1)`.

```text
The H1 takes the subtitle's text without its backticks; the subtitle and the blank lines around it go.
A blank line is put back when a body line followed the subtitle directly, so the heading and what follows stay apart.
```
