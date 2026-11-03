# pwsh/Base.Languages/New-BicepConfig.ps1

The generator of the bicepconfig.json files that point the Bicep compiler at the configured package source.

## help

### synopsis

Returns the target path and content of each bicepconfig.json for the folders of the tracks that hold Bicep.

### description

Builds one settings document from the bicep config: its analyzers and a `br` module alias named after the package source, whose registry is
the first segment of the source url and whose module path is the rest. The same content is returned for each existing folder of a track that
lists bicep, so the compiler finds the nearest `bicepconfig.json`. Only targets that match `-Target` are returned.

### parameter `Target`

A case-sensitive wildcard that selects which `<place>/bicepconfig.json` targets are returned; defaults to all.

### parameter `RepositoryRoot`

The repository root the track places are checked against; defaults to the current repository root.

### outputs

`[pscustomobject]` One object per file, with `Target` (the repository-relative path) and `Content` (the file text).

### example 1

```powershell
New-BicepConfig -Target 'bicep/*'
```
