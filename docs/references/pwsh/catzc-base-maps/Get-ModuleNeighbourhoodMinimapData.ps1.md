# pwsh/Catzc.Base.Maps/Get-ModuleNeighbourhoodMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The module neighbourhood minimap's data: the modules a diagram's subject sits in, ringed by what they depend on and what depends on them.

### description

The subject is the files the ADR codes light on the world map. Their modules form the lit `subject` ring; the modules those depend on form
the `depends-on` ring and the modules that depend on them the `used-by` ring, read from the module dependency registry
([ADR-AUTO-DEPM](../../../drs/automation/controlling-module-dependencies.md)). A neighbour's count is how many subject modules it is joined
to. Each lit cell carries the file and the requested code as its reason, its module type as the note, in the minimap contract's shape.

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
(Get-ModuleNeighbourhoodMinimapData ADR-AUTO-DEPM).Cells
```
