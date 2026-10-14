# docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md

`CD binds through units, CI binds track sets: the diagram described`

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 named sets (mauve), 3 runners (slate); 6 edges; 6 markers; 1 count chip.
Sidebar: axis minimap (main cell DSGN x GLOBS), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/units-not-tracks-own-the-pipelines.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds seven glyphs (four named sets and three runners) joined by six
edges, with six markers, one count chip and a legend panel along the bottom. The eye lands first on the tall named set in the TRACKS band.

## Reading path

1. Marker 1, TRACKS band, top: the named set automation.
2. Marker 2, beside the dashed edge that rises from infrastructure to automation.
3. Marker 3, just below the long edge from automation across to the runner ci-automation; the parallel edge below runs from infrastructure
   to ci-infrastructure.
4. Markers 4 and 5, DEPLOYABLE-UNITS band, bottom row: the named sets foundation base unit and nova · apex · flux · shared, joined by a
   thick edge, with a thick edge entering the first from infrastructure.
5. Marker 6, PIPELINES band, bottom: the runner cd-&lt;unit&gt;, with the count chip 4 on its top-right corner.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | automation, infrastructure (TRACKS band, the second tall); foundation base unit, nova · apex · flux · shared (DEPLOYABLE-UNITS, bottom) |
| runner                | 3     | ci-automation, ci-infrastructure, cd-&lt;unit&gt; (PIPELINES band, one per row)                                                         |

Named sets are mauve and runners slate, both with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| flow      | 3     | automation → ci-automation (marker 3), infrastructure → ci-infrastructure, nova · apex · flux · shared → cd-&lt;unit&gt; |
| thick     | 2     | infrastructure → foundation base unit, foundation base unit → nova · apex · flux · shared                                |
| ADR-only  | 1     | infrastructure → automation (vertical, dashed, marker 2)                                                                 |

Every edge is straight; five are horizontal and one is vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                               |
| ------------------------- | ------------------------------------ |
| mauve rounded box         | named set                            |
| slate pill                | runner                               |
| thin arrow                | flow: binds a pipeline (pipeline:)   |
| thick arrow               | thick: composes into, to a named set |
| dashed arrow              | ADR-only: rests on (no gate)         |
| white pill `4`, slate rim | count chip: pipelines it stands for  |
| dark disc `1`             | marker: a Walkthrough step           |

## Sidebar

- **Axis minimap:** the main cell is DSGN × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. Two touched cells, AUTO ×
  GLOBS and PIPE × BUILD, carry a small grey dot.
- **Tree minimap:** lit tiles labelled Globs, adr/dsgn and pipelines; the adr/dsgn file is framed in dark ink as an ADR file.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
