# Each track picks its catch-all: a stray module file falls to tests, a stray template file to live: the diagram described

```text
A 1572 x 640 diagram, read top to bottom from one wide file into two side-by-side column bands.
Glyphs: 1 file (olive), 4 named sets (mauve); 4 thick edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-aspect--each-track-picks-its-catch-all--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](each-track-picks-its-catch-all.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. One wide file
glyph spans the top of the drawing area, and below it two column bands sit side by side, labelled `CODE TRACK: AUTOMATION` on the left and
`DEPLOYMENT TRACK: INFRASTRUCTURE` on the right. Each band holds two named sets, one above the other. Four thick edges point down, five
markers number the glyphs, and a legend panel runs along the bottom. The eye lands first on the wide olive file at the top.

## Reading path

1. Marker 1, top: the wide file a tracked file of a unit.
2. Down the left thick edge into the left band: marker 2, the named set live; then down to marker 3, the named set tests.
3. Down the right thick edge into the right band: marker 4, the named set tests; then down to marker 5, the named set live.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| file                  | 1     | a tracked file of a unit (top, spanning both columns)                                   |
| named set             | 4     | live and tests (left band, top and bottom), tests and live (right band, top and bottom) |

The file is olive and the named sets are mauve, all with white names.

## Edges

| Edge kind              | Count | From → to                                                                                                                   |
| ---------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------- |
| thick (to a named set) | 4     | a tracked file of a unit → live (left), live → tests (left); a tracked file of a unit → tests (right), tests → live (right) |

Every edge is straight and vertical, pointing down. The two edges that leave the file start at its lower edge above each column's centre.
None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in one row of four, left to right:

| Swatch            | Phrase                                       |
| ----------------- | -------------------------------------------- |
| olive folded page | file                                         |
| mauve rounded box | named set                                    |
| thick arrow       | to a named set: tried next, first match wins |
| light disc `1`    | marker: a Walkthrough step                   |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-ASPECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-aspect--each-track-picks-its-catch-all--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-aspect--each-track-picks-its-catch-all--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-aspect--each-track-picks-its-catch-all--meta.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
