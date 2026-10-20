# pwsh/Catzc.Base.Maps/Get-LifecyclePositionMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The lifecycle position minimap's data: the promotion ladder's rungs, lit where a diagram's subject concerns them.

### description

The subject is the files the ADR codes light on the world map. Each rung of the rungs registry (Get-Rung) is a cell, in climbing order, and
a subject file lights a rung when one of its citations is one of the rung's rules or the ADR that holds the rule
([ADR-FLOW-CD-RUNGSREGISTRY](../../../adr/flow/cd-discipline-and-promotion-flow.md#rule-adr-flow-cd-rungsregistry)). Each lit cell carries
the file, the requested code and the rule as its reason, in the minimap contract's shape.

### parameter `Adr`

The ADR codes of the diagram's subject.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-LifecyclePositionMinimapData ADR-FLOW-CD).Lit
```
