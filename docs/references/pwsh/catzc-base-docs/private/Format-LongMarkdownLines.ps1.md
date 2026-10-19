# pwsh/Catzc.Base.Docs/private/Format-LongMarkdownLines.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Re-wraps the Markdown blocks that have a line past the width, and leaves every other line as it was.

### description

A generated README is its source article with the links rebased to the README's folder, and a rebased link is longer than the source's, so a
line the source wrapped at the width can pass it in the copy. Each paragraph, list item or quote with a line past the width is filled again
at the width, keeping its list marker or quote prefix and the indentation of its continuation lines; fences, tables, headings, rules and
HTML lines are never touched, so a copy whose lines already fit stays byte for byte what its source had.

### parameter `Text`

The Markdown text, with LF line endings.

### parameter `Width`

The column a line may not pass, 140 by default, the width the Markdown formatter and markdownlint use.

### outputs

`[string]` The text with every over-long block filled again at the width.

### example 1

```powershell
Format-LongMarkdownLines -Text $rebased
```

## comment:1

Above `$skip = '^\s*(\||#|---|\*\*\*|<|```|~~~)'`, written with `#`.

```text
A block is a paragraph, a list item or a quote; only a block with a line past the width is re-wrapped, so a copy whose lines
already fit stays byte for byte what its source had. Fences, tables, headings, rules and HTML lines are never touched.
```
