# pwsh/Catzc.Base.Maps/Get-LayerStackMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The layer stack minimap's data: the layers of the automation, lit by the layer of each ADR a diagram's subject cites.

### description

The subject is the files the ADR codes light on the world map. Each layer the ADR registry names is a cell, in stack order, and a subject
file lights the layer of the ADR its requested code belongs to, the longest matching ADR code winning
([ADR-AUTO-LAYERS-REALISENEVERREDEFINE](../../../adr/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)). Each lit cell carries
the file, the requested code and the ADR as its reason, in the minimap contract's shape.

### parameter `Adr`

The ADR codes of the diagram's subject.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-LayerStackMinimapData ADR-AUTO-IMPORTER).Lit
```
