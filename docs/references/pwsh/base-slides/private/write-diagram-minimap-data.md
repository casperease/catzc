# pwsh/Base.Slides/private/Write-DiagramMinimapData.ps1

The writer of a diagram's minimap data: it computes the minimaps each declaration lists and writes their data for the draw.io kit to draw.

## help

### synopsis

Computes the minimaps each diagram declares and writes their data under out/minimaps/, for the draw.io kit to draw.

### description

Each diagram's declaration is read from its carrier (Get-DiagramDeclarationText) and must name its subject's rule codes in `about.rules`.
The minimaps drawn are the ids its `content.minimaps` lists, each an id or `{ id: { exclude: [cells] } }`, or else the defaults maps.yml
gives its kind (`content.kind`, else reference or explanation by its folder); each id must be a minimap maps.yml names a data command for.
The declaration holds these inputs only, never the computed cells. The world map and the subject's file facts are read once for the whole
call and handed to the data commands that take them. Per diagram, each minimap's drawn data is written to `<id>.json`: the computed lit
cells less the ones its `exclude:` names, so a new citing file changes the drawing and never the declaration; `minimaps.json` holds the ids
in order.

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

## What is computed

Each declared folder's three minimaps are computed from its rule codes by the data command `maps.yml` names per id, and written as
`out/minimaps/<folder>/<id>.json` beside `minimaps.json`, the ids in order. The kit's put draws from them and computes nothing.

## What the declaration holds

The declaration lists only the inputs: each shown minimap is an id, or `{ id: { exclude: [cells] } }` naming the lit cells its author
rejects as their `at` values joined by `/`; a declaration that lists none shows its kind's defaults. The drawn data is the computed one less
the excluded cells; nothing computed is written back to the declaration.

## Shared reads

The world map is built once for every folder of the call, and the file facts of every folder's subject are read in one call; a minimap that
draws on either is handed it rather than building its own. The drawing's own glyphs are handed to the minimaps that place them: the labels
as written, resolved by the maps module, never stored.

## comment:1

Above `$commit = Get-GitCurrentCommit`, written with `#`.

```text
The world map is built once for every folder of the call; a minimap that draws on it is handed it rather than building its own.
The data is the committed HEAD's alone, resolved once: never the index, the working tree or a moving HEAD.
```
