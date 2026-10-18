# pwsh/Catzc.Base.CodeMeta/Format-CodeMetaHead.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns a code text with its meta head imprinted from the given facts.

### description

The same facts always give the same bytes, so a second run changes no file and a formatter never undoes the head.

It rests on [ADR-REPO-FILEMETA#3](../../../adr/repository/file-meta.md#rule-adr-repo-filemeta3).

### parameter `Text`

The whole code file as text.

### parameter `Form`

The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.

### parameter `Immutable`

The place facts, an ordered dictionary of key to value.

### parameter `Edges`

The outgoing edges, an ordered dictionary of edge name to value; no facts and no edges removes the head.

### outputs

`[string]` the whole text, with the head replaced.

### example 1

```powershell
Format-CodeMetaHead -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) -Immutable ([ordered]@{ path = 'automation/Widget/types/Gadget.cs'; module = 'Widget' })
```
