# pwsh/Base.CodeMeta/Format-CodeMetaHead.ps1

The formatter's one entry point for a code file's meta head: it takes the whole file text, the head's comment syntax and the facts, and
returns the text with the head written, replaced or removed. The work is pure text on `Catzc.Base.CodeMeta.CodeMetaHead`; the file is read
and written by the caller.

## help

### synopsis

Returns a code text with its meta head imprinted from the given facts.

### description

The same facts always give the same bytes, so a second run changes no file and a formatter never undoes the head.

It rests on [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts).

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
