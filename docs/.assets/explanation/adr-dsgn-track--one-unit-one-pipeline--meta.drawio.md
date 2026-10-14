# docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md

`One unit, one pipeline; tracks ship through units: the diagram described`

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 2 named sets (mauve), 1 runner (slate); 1 thick edge, 1 flow edge; 5 markers.
Sidebar: axis minimap (main cell DSGN x GLOBS), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png) draws, in the vocabulary of the diagram glyphs;
what it means is in [the article](../../explanation/design/one-unit-one-pipeline.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds three glyphs (two named sets and one runner) in one row,
joined by two edges, with five markers and a legend panel below. The drawing area ends at about 390 px; the sidebar runs to the canvas
foot. The eye lands first on the left named set.

## Reading path

1. Marker 1, TRACKS band: the named set Track.
2. Marker 2, beside the thick edge right to the next band.
3. Marker 3, DEPLOYABLE-UNITS band: the named set Deployable-unit.
4. Marker 4, beside the thin edge right to the last band.
5. Marker 5, PIPELINES band: the runner Pipeline.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                        |
| --------------------- | ----- | ------------------------------------------------------------ |
| named set             | 2     | Track (TRACKS band), Deployable-unit (DEPLOYABLE-UNITS band) |
| runner                | 1     | Pipeline (PIPELINES band)                                    |

Named sets are mauve and the runner is slate, both with white names.

## Edges

| Edge kind | Count | From → to                             |
| --------- | ----- | ------------------------------------- |
| thick     | 1     | Track → Deployable-unit (marker 2)    |
| flow      | 1     | Deployable-unit → Pipeline (marker 4) |

Both edges are straight and horizontal, on one line; each edge marker sits just below its line, its rim touching it.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| mauve rounded box | named set                            |
| slate pill        | runner                               |
| thick arrow       | thick: composes into, to a named set |
| thin arrow        | flow: binds one pipeline (1-1)       |
| dark disc `1`     | marker: a Walkthrough step           |

## Sidebar

- **Axis minimap:** the main cell is DSGN × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. One touched cell,
  AUTO × GLOBS, carries a small grey dot.
- **Tree minimap:** lit tiles labelled Globs and adr/dsgn; the adr/dsgn file is framed in dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
