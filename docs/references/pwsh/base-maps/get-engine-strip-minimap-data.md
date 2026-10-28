# pwsh/Base.Maps/Get-EngineStripMinimapData.ps1

The data of the engine strip minimap: each execution engine beside the file languages it runs, lit where a diagram's subject files are
written.

## help

### synopsis

The engine strip minimap's data: each execution engine beside the script languages it runs, lit where a diagram's subject is written.

### description

The subject is the files the rule codes light on the world map. Each execution engine is paired with every file language whose extensions
include one of its script extensions, and a subject file lights the pair of its own file language with each engine that runs it, its module
as the note ([ADR-AUTO-ENGINE](../../../drs/automation/execution-engines.md)). A file in a language no engine runs lights nothing here. Each
lit cell carries the file and the requested code as its reason, in the minimap contract's shape.

### parameter `Rule`

The rule codes of the diagram's subject.

### parameter `WorldMap`

The world map the subject is lit on, built once by a caller that draws many minimaps in one run. Default: the map Get-WorldMap builds.

### parameter `Facts`

The file facts of the subject's paths, read once by Get-MinimapFact for a caller that draws many minimaps in one run. Default: the facts
read for this subject alone.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-EngineStripMinimapData ADR-AUTO-ENGINE).Lit
```

## Which language an engine runs

An engine runs a file language when the language's extensions include one of the engine's script extensions. The pairs are built from
`Get-FileLanguage` and the engine registry.
