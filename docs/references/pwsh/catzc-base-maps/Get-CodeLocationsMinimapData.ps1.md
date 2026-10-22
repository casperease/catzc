# pwsh/Catzc.Base.Maps/Get-CodeLocationsMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The code locations minimap's data: the tracks, modules and folders a diagram's subject files sit in, each lit by its files.

### description

The subject is the files the ADR codes light on the world map. Each subject file with a track fact is placed at its track, its module ('-'
outside one) and its folder under the module ('.' at its root); only the places a subject file sits in are drawn, sorted, and a place counts
each subject file once. Each lit cell carries the file and the requested code as its reason, in the minimap contract's shape.

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
(Get-CodeLocationsMinimapData ADR-AUTO-ENGINE).Lit
```

## comment:1

Above `$count = @{}`, written with `#`.

```text
Where the subject's code lives, with no static frame: each place is a track, the module in it ('-' outside one) and the
folder under the module ('.' at its root), and only the places a subject file sits in are drawn, each lit by its files.
```
