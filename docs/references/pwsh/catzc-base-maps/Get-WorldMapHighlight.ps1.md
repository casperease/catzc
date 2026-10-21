# pwsh/Catzc.Base.Maps/Get-WorldMapHighlight.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the world-map cells that ADR codes or a drawing's files light.

### description

Builds the world map (Get-WorldMap) and lights its cells with Catzc.Base.Maps.WorldMapHighlight.

-Adr lights, for each code (`ADR-<CODE>`, or one rule as `ADR-<CODE>#n` or `ADR-<CODE>:n`): the ADR files of the code's domain, and every
file whose citations name it, in the fixed order per artifact kind the map derives (module code by its own citations, a repository-root file
by its files.yml owner, a pipeline by its citations or else its globset). The reviewed exceptions and pins of configs/maps.yml then apply:
an exception keeps its cell dark and a pin lights its cell. -Path lights the cells the given tracked files sit in
([ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER](../../../adr/design/tracks.md#rule-adr-dsgn-track-trackisplacedcluster)).

With neither, it answers "where does my change sit on the map": the files the working tree changes against HEAD and the index (modified,
added, deleted or untracked; Get-GitChangedPath) light the cells they sit in, as with -Path. The map holds the files git tracks, so a
changed file it does not hold (an untracked file, or one whose removal is staged) lights nothing and is named in the verbose stream. With no
change, no cell is lit.

### parameter `Adr`

The ADR codes, each optionally narrowed to one rule (#n or :n). An unknown code throws.

### parameter `Path`

The repository-relative paths of tracked files. A path the map does not hold throws.

### parameter `WorldMap`

The world map to light, built once by a caller that lights many subjects in one run. Default: the map Get-WorldMap builds.

### parameter `AsJson`

Return the highlight as JSON (the request, and the lit cells with their files and each file's reason: the basis, the covering request and
the citation sites with their lines and kinds) instead of the object
([ADR-THES-ONETRUTH-TRUTHISQUERYABLE](../../../adr/thesis/one-source-of-truth.md#rule-adr-thes-onetruth-truthisqueryable)).

### outputs

`[Catzc.Base.Maps.WorldMapHighlight]`, or `[string]` with -AsJson.

### example 1

```powershell
(Get-WorldMapHighlight).Cells             # the cells the working tree's changes sit in
```

### example 2

```powershell
(Get-WorldMapHighlight ADR-FLOW-CD).Cells
```

### example 3

```powershell
Get-WorldMapHighlight -Adr 'ADR-DSGN-TRACK-ONETECHSTACK' -AsJson
```

### example 4

```powershell
Get-WorldMapHighlight -Path '.ado/pipelines/ci-pwsh.yaml', 'pwsh/Catzc.Base.Maps/Get-WorldMap.ps1'
```
