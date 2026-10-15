# docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The title is the first non-blank line after an optional YAML front-matter block; it must be the H1
`# <repository-relative path>`. Only that line is read as the title, so a `#` line in a later fenced code block
never counts. Kind is Ok, Wrong (an H1 with other text), or Missing (the first line is not an H1). A Wrong title
is replaced and its old text kept as the body's first line — the path H1, a blank line, the old title's text
between single backticks, then a blank line before what followed — so no authored wording is lost and the kept
title reads as the old title, not as prose. A Missing title is inserted with
a blank line before the first line. Fixed is the corrected file text, keeping the file's own line endings; it
equals the input when Kind is Ok.
```

## comment:2

Above ``$oldTitle = ($actual -replace '^#\s+', '' -replace '`', '').TrimEnd()``.

```text
Keep the old title's wording as the body's first line, in backticks; pad it so the heading and what follows stay apart.
The title's own backticks are dropped: inside the one code span they would split it.
```
