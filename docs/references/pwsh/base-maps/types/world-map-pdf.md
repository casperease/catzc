# pwsh/Base.Maps/types/WorldMapPdf.cs

Draws the world map onto `PdfDocument` pages: the grid page and the tree page.

## The pages

The grid page has the tracks as rows and the file languages as columns, each cell shaded by its file count. The tree page is a squarified
treemap of the tracks by file count, each track holding its non-empty cells, with a name band. The catch-all row prints the root-file label
and the catch-all column the unlisted-file label ([DDR-TRACK-ROOTFILE](../../../../drs/design/tracks.md#rule-ddr-track-rootfile),
[DDR-TRACK-UNLISTEDFILE](../../../../drs/design/tracks.md#rule-ddr-track-unlistedfile)). A cell that breaks its track's tech-stack is marked
([DDR-TRACK-ONETECHSTACK](../../../../drs/design/tracks.md#rule-ddr-track-onetechstack)), and an optional `WorldMapHighlight` outlines its
lit cells on top of everything else. Both pages end with the legend. The grid page draws, in order over the background, the title, the
headers, the shaded cells with their counts, the violation marks, the highlight outlines and the legend.

## Look

Every page starts with the full-page background fill, so a viewer in dark or light mode shows the palette's background rather than its own.
Colours, titles, legend entries and the page size come from `MapsConfig`. The shade of a cell is the palette's cell colour when empty, else
a point on the scale from cell to shade, logarithmic in the count so a few files and a thousand both read. Everything is a function of the
map, the config and the highlight, so the bytes are the same on every run.

## Fitting text

A track or file-language name is cut to its character limit (`Truncate`, `ColumnLabel`), and any label then shrinks and is cut further, both
with the marker `…`, so nothing overflows its box.

- `Fit` returns the text at the given size when it fits, else at a smaller size (in half points) no smaller than the minimum, else at the
  minimum cut from the end with the marker, keeping at least one character. It returns empty when not even one character and the marker fit,
  or when the minimum is above the size: a bare marker says nothing, so the label is left out.
- `FitLines` fits a text on at most two lines, in this order: one line at the given size; else broken in two at a space (dropped) or after a
  hyphen (kept), at the break that leaves the wider line narrowest (the first such break on a tie), at the given size; else that break at a
  smaller size no smaller than the minimum; else at the minimum with each line cut from the end with the marker. A text with no break is
  fitted on one line as `Fit` does. A grid column header therefore wraps onto a second line first, and only then shrinks and is cut.
