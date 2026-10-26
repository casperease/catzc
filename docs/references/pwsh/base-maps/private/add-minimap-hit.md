# pwsh/Base.Maps/private/Add-MinimapHit.ps1

The helper every minimap data command uses to record one reason a cell is lit, counting each subject file once per cell.

## help

### synopsis

Records one reason a minimap cell is lit, counting each subject once per cell.

### description

The cell is keyed by its place joined with a tab. The reason is added to the cell's reason list, and the cell's count grows by one only when
no reason of the same subject lights it yet, however many requested codes light the cell through that subject. Both tables are changed in
place, ready for New-MinimapData.

### parameter `Count`

The count of each cell, keyed by its place joined with a tab; changed in place.

### parameter `Reasons`

The MinimapReason list of each cell, keyed the same way; changed in place.

### parameter `At`

The cell's place, one value per axis.

### parameter `Reason`

The reason that lights the cell; its Subject decides whether the count grows.

### outputs

None; -Count and -Reasons are changed in place.

### example 1

```powershell
Add-MinimapHit -Count $count -Reasons $reasons -At @('widget', 'gadget') -Reason $reason
```
