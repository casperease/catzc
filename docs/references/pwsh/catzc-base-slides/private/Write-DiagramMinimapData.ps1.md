# pwsh/Catzc.Base.Slides/private/Write-DiagramMinimapData.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Computes the minimaps each diagram declares and writes their data under out/minimaps/, for the draw.io kit to draw.

### description

Each diagram's declaration is read from its carrier (Get-DiagramDeclarationText) and must name its subject's ADR codes in `about.adrs`. The
minimaps drawn are the ids its `content.minimaps` maps, or else the defaults maps.yml gives its kind (`content.kind`, else reference or
explanation by its folder); each id must be a minimap maps.yml names a data command for. The world map and the subject's file facts are read
once for the whole call and handed to the data commands that take them. Per diagram, each minimap's whole data is written to
`computed/<id>.json` and its drawn data to `<id>.json`, lighting only the cells the declaration lists, with a warning naming every lit cell
it drops; `minimaps.json` holds the ids in order.

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

Above `[System.IO.File]::WriteAllText((Join-Path $computed "$id.json"),...`, written with `#`.

```text
The computed data is kept whole for the declaration's writer; the drawn data lights only the cells the declaration lists,
and a dropped cell is reported, since a lit cell nobody declared is unverifiable.
```
