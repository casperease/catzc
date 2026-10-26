# pwsh/Base.Maps/Get-ValueChainMap.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the value-chain map: the rows of the value-chain stack crossed with the value-chain concerns, and the ADRs in each cell.

### description

Builds the value-chain map ([DDR-TRACK-VALUECHAINMAP](../../../drs/design/tracks.md#rule-ddr-track-valuechainmap)) with
Catzc.Base.Maps.ValueChainMap from drs.yml: the rows are the value-chain stack the registry type declares (Catzc.Base.Drs.DrsConfig Stacks,
[DDR-TRACK-VALUECHAINSTACK](../../../drs/design/tracks.md#rule-ddr-track-valuechainstack)), the columns its value-chain concerns (DrsConfig
Concerns, [DDR-TRACK-VALUECHAINCONCERN](../../../drs/design/tracks.md#rule-ddr-track-valuechainconcern)), and each ADR (Get-DrsRuleSet) sits
on its ADR domain's row in the column of each of its value-chain concerns. Every row meets every column, so the map holds every cell, empty
ones included, row by row.

### parameter `AsJson`

Return the map as JSON (the rows, the columns, and every cell with its ADRs) instead of the object
([TDR-ONETRUTH-TRUTHISQUERYABLE](../../../drs/thesis/one-source-of-truth.md#rule-tdr-onetruth-truthisqueryable)).

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
