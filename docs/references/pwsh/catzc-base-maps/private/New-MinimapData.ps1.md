# pwsh/Base.Maps/private/New-MinimapData.ps1

The helper every minimap data command ends with: it assembles the MinimapData from the axes, the cells and the counts and reasons gathered
for them.

## help

### synopsis

Builds a minimap's data from its axes, its cells and the counts and reasons gathered for them.

### description

Each axis becomes a MinimapAxis with its values, in the order given. Each cell is drawn with the count held under its place joined with a
tab (0 when none), and a cell with reasons is also listed as lit, carrying them. The result is the MinimapData every minimap builder
returns.

### parameter `Id`

The minimap's id, one of the ids MinimapData declares.

### parameter `Axes`

The axes in order, each name with its values.

### parameter `Cells`

The places drawn, one value per axis each, in drawing order.

### parameter `Count`

The count of each cell, keyed by its place joined with a tab.

### parameter `Reasons`

The MinimapReason list of each lit cell, keyed the same way.

### outputs

`[Catzc.Base.Maps.MinimapData]`

### example 1

```powershell
New-MinimapData -Id ([Catzc.Base.Maps.MinimapData]::CodeLocations) -Axes $axes -Cells $cells -Count $count -Reasons $reasons
```

## Keys

Each cell is keyed by its place joined with a tab. The count table holds what each cell holds, and the reasons table the MinimapReason list
that lights it.
