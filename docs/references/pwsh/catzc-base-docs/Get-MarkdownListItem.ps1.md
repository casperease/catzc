# pwsh/Catzc.Base.Docs/Get-MarkdownListItem.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$start = 0`, written with `#`.

```text
A list item is a `-` or `N.` line with the indented lines that continue it, as the markdown formatter wraps it; a blank line, an
unindented line or the next item ends it.
```
