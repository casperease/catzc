# docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md

`Peers never overlap, except loose-filesets: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 1 gate (grey); 2 flow edges; 4 markers.
Sidebar: axis minimap (main cell PIPE x GLOBS), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/peers-in-a-layer-never-overlap.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three named sets and one gate, joined by two flow edges,
with four markers and a legend panel along the bottom. The eye lands first on the gate at the right of the top band.

## Reading path

1. Marker 1, top band: the named set What ships.
2. Marker 2, middle band: the named set Cross-cutting surfaces, with no edge.
3. Marker 3, bottom band: the wide named set Module space.
4. Marker 4, on the top vertex of the gate Peers disjoint, top band, and its two edges: left to What ships, down through the middle band
   to Module space.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                               |
| --------------------- | ----- | ----------------------------------------------------------------------------------- |
| named set             | 3     | What ships (top band), Cross-cutting surfaces (middle band), Module space (bottom band, wide) |
| gate                  | 1     | Peers disjoint (top band, right of What ships)                                      |

Named sets are mauve with white names; the gate is a grey rhombus with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                  |
| --------- | ----- | ---------------------------------------------------------- |
| flow      | 2     | Peers disjoint → What ships, Peers disjoint → Module space |

Both edges are straight: one horizontal, one vertical. Neither touches Cross-cutting surfaces.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| grey rhombus      | gate                       |
| thin arrow        | flow: checks its peers     |
| grey band         | band: one layer            |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is PIPE × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. One touched cell,
  AUTO × GLOBS, carries a small grey dot.
- **Tree minimap:** two lit tiles, labelled Globs and adr/flow.
- **Lens badge:** META, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
