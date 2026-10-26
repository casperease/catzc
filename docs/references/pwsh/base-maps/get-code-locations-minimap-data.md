# pwsh/Base.Maps/Get-CodeLocationsMinimapData.ps1

The data of the "Where does it live?" minimap. It has no fixed frame: the places are the tracks, modules and folders a diagram's subject
files sit in, and each place is lit by its files.

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

### parameter `Glyph`

The drawing's own glyphs, each `{ kind; label }`: the places they name come first, the cited ADRs' places only while rows remain. Default:
none.

### parameter `TrackedPath`

Every tracked path, the index a glyph label is resolved against. Default: the tracked paths, read once.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-CodeLocationsMinimapData ADR-AUTO-ENGINE).Lit
```

## Places

A place is a triple: the track, the module in it (`-` outside one) and the folder under the module (`.` at its root). Only the places a
subject file sits in are drawn.

## Glyphs first

A drawing can carry glyphs of its own, each `{ kind; label }`. The places they name come first. Each label is resolved to the repository
files it names; a label that names none is dropped and counted. The places of the cited ADRs follow only while rows remain.

## Rows are computed here

The rows the place list draws are worked out here from the place triples, glyph places first, so the drawing only draws them.
