# pwsh/Base.Slides/private/Write-DiagramQueryRows.ps1

The writer of query rows: it reads the rows of every C3 and C4 slide among the given diagrams and writes them into one JSON file for the
renderer to expand.

## help

### synopsis

Writes the query rows of every C3 and C4 slide among the given diagrams into one JSON file, for the renderer to expand.

### description

A diagram whose declaration names an `about.point` is a query slide: its cells are read from the repository at build time, never written
into its source. Its `about.zoom` picks the rows: `C3` reads the point's components (Get-DiagramComponentRows), `C4` its files
(Get-DiagramCodeRows); a point at any other zoom throws. A point and zoom two diagrams share is read once. A diagram with no declaration, or
one that names no point, adds no row.

The file is `{ "rows": [ ... ] }` in UTF-8 without a byte-order mark, its folder made when absent; an empty set of stems writes an empty row
list.

### parameter `Stem`

The diagrams to read, each as its stem (`<page-folder>/.assets/<name>`).

### parameter `RepositoryRoot`

The repository the diagrams and their points lie in.

### parameter `Path`

The JSON file to write.

### parameter `Config`

The drawing kit's config file; its `flow-readers` map names the PowerShell reader of each track's flow files, for a flow diagram's rows.

### outputs

`[string]` The path written.

### example 1

```powershell
Write-DiagramQueryRows -Stem docs/drs/.assets/drs-domains -RepositoryRoot (Get-RepositoryRoot) -Path out/drawio/query-rows.json
```

## What a slide stores

A C3 or C4 slide stores its level and its point; its cells are the level's query for that point
([DDR-VISUAL-ZOOMISANAXIS](../../../../drs/design/visual-design.md#rule-ddr-visual-zoomisanaxis)).

## comment:1

Above `$readers = $null`, written with `#`.

```text
A C3 or C4 slide stores its level and its point; its cells are the level's query for that point.
A flow slide stores its point and the flow lens; its lanes are the reader's rows for the track its files belong to.
```
