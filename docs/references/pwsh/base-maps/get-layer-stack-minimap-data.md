# pwsh/Base.Maps/Get-LayerStackMinimapData.ps1

The data of the layer stack minimap: the layers of the automation in stack order, each lit when a diagram's subject cites a record that
belongs to it.

## help

### synopsis

The layer stack minimap's data: the layers of the automation, lit by the layer of each record a diagram's subject cites.

### description

The subject is the files the rule codes light on the world map. Each layer the DRS registry names is a cell, in stack order, and a subject
file lights the layer of the record its requested code belongs to, the longest matching record code winning
([ADR-AUTO-LAYERS-REALISENEVERREDEFINE](../../../drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)). Each lit cell carries
the file, the requested code and the record as its reason, in the minimap contract's shape.

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
(Get-LayerStackMinimapData ADR-AUTO-IMPORTER).Lit
```
