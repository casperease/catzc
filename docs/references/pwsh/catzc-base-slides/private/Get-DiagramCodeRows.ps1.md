# pwsh/Base.Slides/private/Get-DiagramCodeRows.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$languages = Get-Config -Config languages`, written with `#`.

```text
C4: one module's tracked files, its tests left out, each a glyph of the kind its folder's role draws, and the link edges between two
of them; a build's output beside the sources is no file of the module.
```

## comment:2

Above `$nodes.Add([ordered]@{ id = $id; label =...`, written with `#`.

```text
The glyph's kind already says what the file is, so its label is the name without the extension, short enough
for its box.
```
