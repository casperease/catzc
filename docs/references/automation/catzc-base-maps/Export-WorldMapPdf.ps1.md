# docs/references/automation/catzc-base-maps/Export-WorldMapPdf.ps1.md

`automation/Catzc.Base.Maps/Export-WorldMapPdf.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Builds the world map (Get-WorldMap) and draws it with Catzc.Base.Maps.WorldMapPdf, one file per view under the
world-map output folder (Get-WorldMapOutputRoot,
[ADR-REPO-OUTDIR#2](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir2)):
  world-map.grid.pdf   rows are the tracks, columns the file languages, each cell shaded by its file count; the
                       catch-all row holds the root files and the catch-all column the unlisted files
                       ([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7),
                       [ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)), and a cell that
                       breaks its track's tech-stack is marked
                       ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3));
  world-map.tree.pdf   the tracks as a treemap by file count, each holding its non-empty cells.
One file per view, not one two-page file: each view is a document of its own that a reader opens, links or
replaces alone, and -View Grid rewrites the grid without touching the tree.

With -Adr or -Path the lit cells (Get-WorldMapHighlight) are outlined on every page, and the files are named
world-map.<view>.highlight.pdf, so a highlight never overwrites the plain map. The colours, titles, legend entries,
label limits and page size come from configs/maps.yml (Get-Config -Config maps). The bytes depend only on the map,
the config and the highlight, so an unchanged repository writes identical files.
```
