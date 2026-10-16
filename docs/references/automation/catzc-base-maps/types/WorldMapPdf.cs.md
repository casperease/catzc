---
catzc:
  immutable:
    with_body_sha: d6159c1acf1b
    path: docs/references/automation/catzc-base-maps/types/WorldMapPdf.cs.md
    folder: docs/references/automation/catzc-base-maps/types
    name: world-map-pdf-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-DSGN-TRACK#{3,7,8}
---

# automation/Catzc.Base.Maps/types/WorldMapPdf.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Draws the world map onto PdfDocument pages: the grid page (rows are the tracks, columns the file languages, each cell
shaded by its file count) and the tree page (a squarified treemap of the tracks by file count, each holding its
non-empty cells). The catch-all row prints the root-file label and the catch-all column the unlisted-file label
([ADR-DSGN-TRACK#7](/docs/adr/design/tracks.md#rule-adr-dsgn-track7),
[ADR-DSGN-TRACK#8](/docs/adr/design/tracks.md#rule-adr-dsgn-track8)). A cell that breaks its track's tech-stack is
marked ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)), and an optional WorldMapHighlight
outlines its lit cells on top of everything else.

Every page starts with the full-page background fill, so a viewer in dark or light mode shows the palette's
background rather than its own. Colours, titles, legend entries and the page size come from MapsConfig; a track or
file-language name is cut to its character limit, and any label then shrinks to the smallest font size and is cut
further, both with the marker '…', so nothing overflows its box. A grid column header first wraps onto a second line
at a space or a hyphen, and only then shrinks and is cut. Everything is a function of the map, the config
and the highlight, so the bytes are the same on every run.
```

## comment:2

Above `public static string ColumnLabel(string fileLanguage, MapsConfig config)`, written with `//`.

```text
The printed header of a column: the unlisted-file label for the catch-all column, else the file-language name cut
to max_column_label.
```

## comment:3

Above `public static string Truncate(string text, int maxChars)`, written with `//`.

```text
The text cut to at most maxChars characters: unchanged when it fits, else its first maxChars - 1 characters and
the marker.
```

## comment:4

Above `public static string Fit(string text, PdfFont font, double size, double...`, written with `//`.

```text
The text as it fits maxWidth points: at the given size when it fits, else at a smaller size (in half points) no
smaller than minSize, else at minSize cut from the end with the marker, keeping at least one character. Empty (and
fittedSize 0) when not even one character and the marker fit, or when minSize is above size: a bare marker says
nothing, so the label is left out.
```

## comment:5

Above `public static string[] FitLines(string text, PdfFont font, double size,...`, written with `//`.

```text
The text as it fits maxWidth points on at most two lines, in this order: on one line at the given size; else
broken in two at a space (dropped) or after a hyphen (kept), at the break that leaves the wider line narrowest
(the first such break on a tie), at the given size; else that break at a smaller size (in half points) no smaller
than minSize; else at minSize with each line cut from the end with the marker, a second line that keeps nothing
left out. A text with no break is fitted on one line as Fit does. Empty (and fittedSize 0) when nothing fits.
```

## comment:6

Above `private static string[] BestBreak(string text, PdfFont font)`, written with `//`.

```text
The two lines of the break in text that leaves the wider line narrowest, the first on a tie; null when the text
has no space or hyphen with something on both sides.
```

## comment:7

Above `public static string ShadeOf(int count, int maxCount, MapsPalette palette)`, written with `//`.

```text
The fill of a cell with the given count: the palette's cell colour when empty, else a point on the scale from
cell to shade, logarithmic in the count so a few files and a thousand both read.
```

## comment:8

Above `public static void AddGridPage(PdfDocument doc, WorldMap map, MapsConfig...`, written with `//`.

```text
The grid page: title, headers, shaded cells with their counts, the stack-violation marks, the highlight outlines
and the legend, in that order over the background.
```

## comment:9

Above `public static void AddTreePage(PdfDocument doc, WorldMap map, MapsConfig...`, written with `//`.

```text
The tree page: the tracks as a squarified treemap by file count, each with a name band and its non-empty cells
laid out inside by file count, then the stack-violation marks, the highlight outlines and the legend.
```

## comment:10

Above `private static void ColumnHeader(PdfPage page, string text, double x, double...`, written with `//`.

```text
A column header fitted into its box on one or two lines (FitLines), each line centred, the block set on the box's
vertical middle, in the current fill colour.
```

## comment:11

Above `private static void Legend(PdfPage page, MapsConfig config, int maxCount,...`, written with `//`.

```text
The legend band: the file-count scale, the stack-violation mark and, with a highlight, the lit-cell outline with
the request.
```
