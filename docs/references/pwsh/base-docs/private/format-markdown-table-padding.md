# pwsh/Base.Docs/private/Format-MarkdownTablePadding.ps1

Pads every markdown table in a text the way the formatter pads one, so a generated page is already in its normal form after rebasing has
lengthened its links.

## help

### synopsis

Pads each markdown table of a text to its widest cell per column.

### description

Collects each run of `|` lines outside a fence, splits it into cells on unescaped pipes, and rewrites it with every cell padded to its
column's width (at least 3) and the separator row as dashes. Fenced lines are left as written.

### parameter `Text`

The markdown text; may be empty.

### outputs

`[string]` the text with its tables padded.
