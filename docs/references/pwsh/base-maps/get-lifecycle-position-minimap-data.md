# pwsh/Base.Maps/Get-LifecyclePositionMinimapData.ps1

The data of the lifecycle position minimap: the rungs of the promotion ladder in climbing order, lit where a diagram's subject concerns
them.

## help

### synopsis

The lifecycle position minimap's data: the promotion ladder's rungs, lit where a diagram's subject concerns them.

### description

The subject is the files the rule codes light on the world map. Each rung of the rungs registry (Get-Rung) is a cell, in climbing order, and
a subject file lights a rung when one of its citations is one of the rung's rules or the record that holds the rule
([FDR-CD-RUNGSREGISTRY](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-rungsregistry)). Each lit cell carries the file,
the requested code and the rule as its reason, in the minimap contract's shape.

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
(Get-LifecyclePositionMinimapData FDR-CD).Lit
```

## Rungs

The rungs come from `Get-Rung` in climbing order. A subject file lights a rung when it cites one of the rung's rules, or the record that
holds the rule.
