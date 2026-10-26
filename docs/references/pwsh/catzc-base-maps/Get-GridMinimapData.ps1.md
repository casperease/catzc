# pwsh/Base.Maps/Get-GridMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The grid minimap's data: the world map's tracks down and file languages across, lit where a diagram's subject files are.

### description

The subject is the files the ADR codes light on the world map (Get-WorldMapHighlight). The data is the world map's own grid, tracks by file
languages, with each cell lit by the subject's files in it and carrying them as its reasons, in the minimap contract's shape.

### parameter `Adr`

The ADR codes of the diagram's subject.

### parameter `WorldMap`

The world map the subject is lit on, built once by a caller that draws many minimaps in one run. Default: the map Get-WorldMap builds.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-GridMinimapData ADR-AUTO-ENGINE).Lit
```
