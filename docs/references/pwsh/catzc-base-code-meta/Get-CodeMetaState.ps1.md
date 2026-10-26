# pwsh/Base.CodeMeta/Get-CodeMetaState.ps1

The read side of the code-file head: it parses a code text with the given comment syntax and reports which sections, immutable keys, edges
and authored config lines the head holds. It never writes, so a gate can compare what a file says against what it should say.

## help

### synopsis

Reads what a code text says about its own meta head, without changing it.

### description

Pure: it takes the text and the head's comment syntax, reads no file and no config.

It rests on [ADR-REPO-CODEMETA-CODEFILEHEAD](../../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead).

### parameter `Text`

The whole code file as text.

### parameter `Form`

The head's comment syntax: a Catzc.Base.CodeMeta.HeadForm.

### outputs

`[pscustomobject]` @{ HasHead; Sections; ImmutableKeys; EdgeKeys; EdgeLists; ConfigLines; Before; Rest; NewLine } — Sections are the keys
directly under `catzc`, ImmutableKeys the keys under `immutable`, EdgeKeys the edge names under `edges`, EdgeLists each list edge with its
items, and ConfigLines the authored lines under `config`, as written.

### example 1

```powershell
Get-CodeMetaState -Text $text -Form ([Catzc.Base.CodeMeta.HeadForm]::ForBlock('/*', '*/')) | Select-Object -ExpandProperty ImmutableKeys
```
