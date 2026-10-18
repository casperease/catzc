# pwsh/Catzc.Base.Maps/Get-ValueChainMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, and the ADRs in each cell.

### description

Builds the value-chain map ([ADR-DSGN-TRACK#16](../../../adr/design/tracks.md#rule-adr-dsgn-track16)) with Catzc.Base.Maps.ValueChainMap
from adrs.yml: the rows are the value-chain stack the registry type declares (Catzc.Base.Docs.AdrsConfig Stacks,
[ADR-DSGN-TRACK#14](../../../adr/design/tracks.md#rule-adr-dsgn-track14)), the columns its value-chain concerns (AdrsConfig Concerns,
[ADR-DSGN-TRACK#15](../../../adr/design/tracks.md#rule-adr-dsgn-track15)), and each ADR (Get-AdrRuleSet) sits on its ADR domain's row in the
column of each of its value-chain concerns. Every row meets every column, so the map holds every cell, empty ones included, row by row.

### parameter `AsJson`

Return the map as JSON (the rows, the columns, and every cell with its ADRs) instead of the object
([ADR-THES-ONETRUTH#3](../../../adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth3)).

### outputs

`[Catzc.Base.Maps.ValueChainMap]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-ValueChainMap).Cells | Where-Object AdrCount -gt 0
```

### example 2

```powershell
(Get-ValueChainMap).Cell('AUTO', 'quality-control').Adrs
```

### example 3

```powershell
Get-ValueChainMap -AsJson
```
