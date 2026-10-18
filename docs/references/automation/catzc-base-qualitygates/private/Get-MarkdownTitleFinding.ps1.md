---
catzc:
  immutable:
    with_body_sha: "4a419dac15d2"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-MarkdownTitleFinding.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-markdown-title-finding-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-MarkdownTitleFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Checks one Markdown file's title and returns the fixed text.

### description

The title is the first non-blank line after an optional YAML front-matter block; it must be an H1 that is not the
file's own repository path (the path is a derived meta fact, never the title). Only that line is read as the title,
so a `#` line in a later fenced code block never counts. Kind is Ok (an H1 that is a title), PathTitle (the H1 is
the path and one code-span line follows), Untitled (the H1 is the path and nothing titles it), or Missing (the first
line is not an H1). A PathTitle is repaired: the H1 takes the code-span line's text without its backticks and the
line goes, so no authored wording is lost. Untitled and Missing have no repair, since nothing can invent a title: a
person writes it. Fixed is the corrected file text, keeping the file's own line endings; it equals the input for every
Kind but PathTitle.

### parameter RelativePath

The file's repository-relative, '/'-separated path — the H1 that is no title.

### parameter Text

The file's content.

### outputs

`[pscustomobject]` @{ Path; Line; Kind; Actual; Expected; Fixed }

## comment:1

Above `$lines.RemoveRange($titleIndex, $subtitleIndex - $titleIndex + 1)`, written with `#`.

```text
The H1 takes the subtitle's text without its backticks; the subtitle and the blank lines around it go.
A blank line is put back when a body line followed the subtitle directly, so the heading and what follows stay apart.
```
