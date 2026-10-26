# pwsh/Base.Docs/Get-MarkdownListItem.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Reads the list items of a markdown text, each with its continuation lines joined.

### description

A list item starts at a `-` or `N.` line, at any indent, and takes in each following line indented by two or more spaces, trimmed and joined
with one space. A blank line, an unindented line or the next item ends it. Lines outside any item are skipped.

### parameter `Line`

The lines of the markdown text.

### outputs

`[pscustomobject]` one per item: LineNumber (1-based, the item's first line), First (that line as written) and Text (the item with its
continuation lines joined).

### example 1

```powershell
Get-MarkdownListItem ([System.IO.File]::ReadAllLines($plan))
```

## comment:1

Above `$start = 0`, written with `#`.

```text
A list item is a `-` or `N.` line with the indented lines that continue it, as the markdown formatter wraps it; a blank line, an
unindented line or the next item ends it.
```
