# pwsh/Base.Maps/Test-PlaceRows.ps1

The check that every row a code-locations minimap prints is in the one minimised place form, so a drawing never carries a longer row than
the maps config allows.

## help

### synopsis

Whether every row a minimap's data carries is already in the place normal form.

### description

Reads each code-locations minimap data file under the path that carries `place_rows` and reports every row that is not in the one minimised
form of the maps config, and a counters line longer than the row budget (ADR-AUTO-IDIOM-PLACENORMALFORM). Returns one finding for each
offending row, and none when all are normal.

### parameter `Path`

The folder of minimap data files to read, such as `out/minimaps`; mandatory, since no default reaches the output track
(ADR-AUTO-DEFAULT-OUTPUTONLYBYADDRESS).

### outputs

`[string]` One finding for each row or counters line that is not in the normal form.

### example 1

```powershell
Test-PlaceRows
```
