# docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md

`Every entry runs one load sequence: the diagram described`

```text
A 1572 x 624 diagram, read top to bottom down one column in one band.
Glyphs: 4 code units (slate), 1 gate; 4 flow edges; 5 markers.
Sidebar: axis minimap (main cell AUTO x LOAD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/every-entry-runs-one-load-sequence.md).

## At a glance

A 1572 × 624 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one centred
column inside a full-width band labelled LOAD SEQUENCE. It holds five glyphs, four code units and one gate, joined by four straight edges,
with five markers and a legend panel along the bottom. The eye lands first on the gate, the only rhombus, fourth in the column.

## Reading path

1. Marker 1, top of the column: the code unit Enter.
2. Markers 2 and 3: the code units Set up the session and Load.
3. Marker 4, on the gate's left point: the gate Prove one run mode.
4. Marker 5, bottom of the column: the code unit Tidy, then leave.

## Glyphs

| Glyph (legend phrase) | Count | Where                     |
| --------------------- | ----- | ------------------------- |
| code unit             | 4     | column rows 1, 2, 3 and 5 |
| gate                  | 1     | column row 4              |

Code units are slate with white names; the gate is a light grey rhombus with a thick rim.

## Edges

| Edge kind        | Count | From → to                                       |
| ---------------- | ----- | ----------------------------------------------- |
| flow (runs next) | 4     | each glyph to the one below it, down the column |

Every edge is short, straight and vertical. None carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| thin arrow              | flow: runs next            |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is AUTO × LOAD, framed and filled in the LOAD indigo with the you-are-here dot. One touched cell, AUTO ×
  BUILD, carries a small grey dot.
- **Tree minimap:** lit tiles labelled .internal, adr/auto and (root); the adr/auto file is framed in dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
