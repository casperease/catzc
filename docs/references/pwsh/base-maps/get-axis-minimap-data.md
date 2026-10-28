# pwsh/Base.Maps/Get-AxisMinimapData.ps1

The data of the axis minimap: the value chain cut a second way, the top DRS domains down and the delivery concerns across. A diagram's
subject lights the cells its rule codes sit in.

## help

### synopsis

The axis minimap's data: the value chain re-cut by the minimap axis of maps.yml, lit where a diagram's subject is placed.

### description

The rows are the axis rows of the maps config, each gathering its value-chain stacks, and the columns are its delivery concerns. A cell
holds the record count of the value-chain cells it gathers, and is lit by the requested rule codes Get-ValueChainHighlight places there,
each reason marked as placed by its domain or by a concern override. A record whose concerns all fall outside the columns lights its whole
row instead, at the place [row, '*'], with the concern it sits under as the note.

### parameter `Rule`

The rule codes of the diagram's subject.

### parameter `AsJson`

Return the data as JSON in the minimap contract's shape instead of the object.

### outputs

`[Catzc.Base.Maps.MinimapData]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-AxisMinimapData ADR-AUTO-ENGINE).Lit
```

## Where the rows come from

The `minimap_axis` setting of the maps config (`configs/maps.yml`) names the rows and their value-chain stacks. Each row is one top DRS
domain gathering its stacks. A cell holds the records placed there and is lit by the codes the diagram covers.
