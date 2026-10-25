# pwsh/Catzc.Base.Maps/Get-TrackPlacementMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The track placement minimap's data: every track under its track type, lit where a diagram's subject sits.

### description

The subject is the files the ADR codes light on the world map. Each track of the tracks registry (Get-Track) is a cell under its track type,
and a subject file lights the track its file facts place it in (Get-FileMetaFact), its vendor as the note
([DDR-TRACK](../../../drs/design/tracks.md)). Each lit cell carries the file and the requested code as its reason, in the minimap contract's
shape.

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
(Get-TrackPlacementMinimapData ADR-AZ-NAMING).Lit
```
