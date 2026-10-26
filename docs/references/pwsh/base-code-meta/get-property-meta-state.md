# pwsh/Base.CodeMeta/Get-PropertyMetaState.ps1

The read side of the property carrier: it parses a JSON text or an MSBuild project and reports whether the meta property is there, whether
it holds something foreign, and which sections, immutable keys, edges and authored config lines it holds. It never writes, so a gate can
compare what a file says against what it should say.

## help

### synopsis

Reads what a JSON text or an MSBuild project says about its own meta property, without changing it.

### description

Pure: it takes the text and the property's name, reads no file and no config
([ADR-REPO-FILEMETA-JSONCARRIER](../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-jsoncarrier)). The property is an ignored
top-level member of a JSON file, or the CDATA property inside the first PropertyGroup labelled catzc of an MSBuild project.

### parameter `Text`

The whole JSON file or MSBuild project as text.

### parameter `Property`

The name of the property that holds the block (e.g. // or $comment in JSON, CatzcMeta in a project).

### parameter `Strip`

Beginnings of old values of the property that Format-PropertyMetaHead replaces instead of leaving as foreign.

### outputs

`[pscustomobject]` @{ IsObject; HasHead; Foreign; Sections; ImmutableKeys; EdgeKeys; ConfigLines } — Sections are the keys directly under
`catzc`, ImmutableKeys the keys under `immutable`, EdgeKeys the edge names under `edges`, and ConfigLines the authored lines under `config`,
as written.

### example 1

```powershell
Get-PropertyMetaState -Text $text -Property '//' | Select-Object -ExpandProperty ImmutableKeys
```
