# pwsh/Base.QualityGates/private/Get-MarkdownTitleFinding.ps1

Checks one Markdown file's title and returns the fixed text. A title is the H1 on the first line, and a path subtitle below it is folded
into the H1.

## help

### synopsis

Checks one Markdown file's title and returns the fixed text.

### description

The title is the first non-blank line after an optional YAML front-matter block; it must be an H1 that is not the file's own repository path
(the path is a derived meta fact, never the title). Only that line is read as the title, so a `#` line in a later fenced code block never
counts. Kind is Ok (an H1 that is a title), PathTitle (the H1 is the path and one code-span line follows), Untitled (the H1 is the path and
nothing titles it), or Missing (the first line is not an H1). A PathTitle is repaired: the H1 takes the code-span line's text without its
backticks and the line goes, so no authored wording is lost. Untitled and Missing have no repair, since nothing can invent a title: a person
writes it. Fixed is the corrected file text, keeping the file's own line endings; it equals the input for every Kind but PathTitle.

### parameter `RelativePath`

The file's repository-relative, '/'-separated path — the H1 that is no title.

### parameter `Text`

The file's content.

### outputs

`[pscustomobject]` @{ Path; Line; Kind; Actual; Expected; Fixed }

## Path title

When a file has a path title, the H1 takes the subtitle's text without its backticks. The subtitle and the blank lines around it go. A blank
line is put back when a body line followed the subtitle directly, so the heading and what follows stay apart.
