# pwsh/Base.Maps/private/Get-MinimapSubject.ps1

The helper that turns a diagram's rule codes into its subject: the files they light on the world map, each with its facts.

## help

### synopsis

Returns the files a diagram's rule codes light on the world map, each with its requested code, its placement citations and its file facts.

### description

The subject is every reason with a path among the cells Get-WorldMapHighlight lights for the codes. Each file comes back with the code that
was requested, the citations of its world-map placement (none when it has no placement), and its file facts. The facts are read once by
Get-MinimapFact for the subject's paths unless a caller hands them in; a path the handed-in facts lack has no facts.

### parameter `Rule`

The rule codes of the diagram's subject.

### parameter `WorldMap`

The world map the subject is lit on, built once by a caller that draws many minimaps in one run. Default: the map Get-WorldMap builds.

### parameter `Facts`

The file facts keyed by path, read once for a caller that draws many minimaps in one run. Default: the facts read for this subject alone.

### outputs

`[pscustomobject]` One per subject file: Path, Requested, Citations, Facts.

### example 1

```powershell
Get-MinimapSubject -Rule ADR-AUTO-ENGINE | ForEach-Object Path
```
