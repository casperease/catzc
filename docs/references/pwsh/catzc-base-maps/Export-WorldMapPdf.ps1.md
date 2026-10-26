# pwsh/Base.Maps/Export-WorldMapPdf.ps1

The command that draws the world map to PDF files, one per view, so a reader can open the grid or the tree on its own. It builds the map,
reads the look from the maps config and writes the files under the world-map output folder.

## help

### synopsis

Writes the world map as PDFs, the grid view, the tree view or both, optionally with a highlight.

### description

Builds the world map (Get-WorldMap) and draws it with Catzc.Base.Maps.WorldMapPdf, one file per view under the world-map output folder
(Get-WorldMapOutputRoot,
[ADR-REPO-OUTDIR-SUBDIRECTORYPERPRODUCER](../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-subdirectoryperproducer)):

```text
world-map.grid.pdf   rows are the tracks, columns the file languages, each cell shaded by its file count; the
                     catch-all row holds the root files and the catch-all column the unlisted files
                     ([DDR-TRACK-ROOTFILE](/docs/drs/design/tracks.md#rule-ddr-track-rootfile),
                     [DDR-TRACK-UNLISTEDFILE](/docs/drs/design/tracks.md#rule-ddr-track-unlistedfile)), and a cell that
                     breaks its track's tech-stack is marked
                     ([DDR-TRACK-ONETECHSTACK](/docs/drs/design/tracks.md#rule-ddr-track-onetechstack));
world-map.tree.pdf   the tracks as a treemap by file count, each holding its non-empty cells.
```

One file per view, not one two-page file: each view is a document of its own that a reader opens, links or replaces alone, and -View Grid
rewrites the grid without touching the tree.

With -Adr or -Path the lit cells (Get-WorldMapHighlight) are outlined on every page, and the files are named
`world-map.<view>.highlight.pdf`, so a highlight never overwrites the plain map. The colours, titles, legend entries, label limits and page
size come from configs/maps.yml (Get-Config -Config maps). The bytes depend only on the map, the config and the highlight, so an unchanged
repository writes identical files.

### parameter `View`

The views to write: Grid, Tree, or both (the default).

### parameter `Adr`

Outline the cells these ADR codes light (each optionally narrowed to one rule, #n or :n).

### parameter `Path`

Outline the cells these tracked files sit in.

### outputs

`[string]` the absolute path of every written file, grid first.

### example 1

```powershell
Export-WorldMapPdf
```

### example 2

```powershell
Export-WorldMapPdf -View Grid -Adr 'DDR-TRACK-ONETECHSTACK'
```

### example 3

```powershell
Export-WorldMapPdf -Path '.ado/pipelines/ci-pwsh.yaml'
```
