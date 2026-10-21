# pwsh/Catzc.Base.Maps/Get-EngineStripMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The engine strip minimap's data: each execution engine beside the script languages it runs, lit where a diagram's subject is written.

### description

The subject is the files the ADR codes light on the world map. Each execution engine is paired with every file language whose extensions
include one of its script extensions, and a subject file lights the pair of its own file language with each engine that runs it, its module
as the note ([ADR-AUTO-ENGINE](../../../adr/automation/execution-engines.md)). A file in a language no engine runs lights nothing here. Each
lit cell carries the file and the requested code as its reason, in the minimap contract's shape.

### parameter `Adr`

The ADR codes of the diagram's subject.

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
