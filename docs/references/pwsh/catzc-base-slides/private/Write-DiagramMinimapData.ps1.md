# pwsh/Base.Slides/private/Write-DiagramMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Computes the minimaps each diagram declares and writes their data under out/minimaps/, for the draw.io kit to draw.

### description

Each diagram's declaration is read from its carrier (Get-DiagramDeclarationText) and must name its subject's ADR codes in `about.adrs`. The
minimaps drawn are the ids its `content.minimaps` lists, each an id or `{ id: { exclude: [cells] } }`, or else the defaults maps.yml gives
its kind (`content.kind`, else reference or explanation by its folder); each id must be a minimap maps.yml names a data command for. The
declaration holds these inputs only, never the computed cells. The world map and the subject's file facts are read once for the whole call
and handed to the data commands that take them. Per diagram, each minimap's drawn data is written to `<id>.json`: the computed lit cells
less the ones its `exclude:` names, so a new citing file changes the drawing and never the declaration; `minimaps.json` holds the ids in
order.

### parameter `Stem`

The diagrams' stems, `.assets/<name>`, repository-relative.

### parameter `RepositoryRoot`

The repository root the stems are under; the data is written under its out/minimaps/.

### outputs

`[string]` The folder each diagram's minimap data was written to.

### example 1

```powershell
Write-DiagramMinimapData -Stem docs/drs/automation/.assets/widget -RepositoryRoot (Get-RepositoryRoot)
```

## comment:1

Above `$maps = Get-Config -Config maps`, written with `#`.

```text
Each declared folder's three minimaps, computed from its ADR codes by the data command maps.yml names per id, written as
out/minimaps/<folder>/<id>.json beside minimaps.json, the ids in order; the kit's put draws from them and computes nothing.
```

## comment:2

Above `$shown = $null`, written with `#`.

```text
The declaration lists only the inputs: each shown minimap is an id, or { id: { exclude: [cells] } } naming the lit cells its
author rejects as their at values joined by '/'; a declaration that lists none shows its kind's defaults.
```

## comment:3

Above `$worldMap = Get-WorldMap`, written with `#`.

```text
The world map is built once for every folder of the call; a minimap that draws on it is handed it rather than
building its own.
```

## comment:4

Above `$glyphs = @(if ($content -and $content.Contains('glyphs') -and...`, written with `#`.

```text
The drawing's own glyphs, handed to the minimaps that place them: the labels as written, resolved by the maps
module, never stored.
```

## comment:5

Above `$subjectPaths = foreach ($entry in $declared) {`, written with `#`.

```text
The file facts of every folder's subject are read in one call; a minimap that draws on them is handed them rather
than reading its own.
```

## comment:6

Above `$excluded = $entry.Excluded[$id]`, written with `#`.

```text
The drawn data is the computed one less the cells the author excludes; nothing computed is written back to
the declaration.
```
