# docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md

`Two layers declared, the third derived: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands under two span bars.
Glyphs: 6 named sets (mauve); 1 thick edge with a 4/4 fraction chip; 6 markers.
Sidebar: axis minimap (main cell PIPE x GLOBS), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/two-declared-layers-one-derived.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE, under two span bars labelled DECLARED (over the left half) and
DERIVED (over the right half). It holds six named sets, one thick edge with a fraction chip, six markers, and a legend panel along the
bottom. The eye lands first on the short thick edge between the two named sets in the top band.

## Reading path

1. The span bars above the top band: DECLARED on the left, DERIVED on the right.
2. Markers 1 and 2, top band, left half: the named sets Configured units and Base unit, joined by the thick edge.
3. Markers 3 and 4, middle band: Declared loose-filesets under DECLARED, Reserved umbrellas under DERIVED.
4. Markers 5 and 6, bottom band, right half: Module sets and module-leftovers. The left half of the bottom band is empty.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                 |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 6     | Configured units, Base unit (top band, left); Declared loose-filesets (middle, left); Reserved umbrellas (middle, right); Module sets, module-leftovers (bottom, right) |

Named sets are mauve with white names.

## Edges

| Edge kind              | Count | From → to                    |
| ---------------------- | ----- | ---------------------------- |
| thick (to a named set) | 1     | Configured units → Base unit |

The edge is short and horizontal, with a bold `4/4` fraction chip just above it.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                             |
| ----------------- | ---------------------------------- |
| mauve rounded box | named set                          |
| grey band         | band: one layer                    |
| thick arrow       | compose, to a named set            |
| bold `4/4`        | fraction chip: units with the edge |
| span bar          | span bar: declared or derived      |
| dark disc `1`     | marker: a Walkthrough step         |

## Sidebar

- **Axis minimap:** the main cell is PIPE × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. One touched cell,
  AUTO × GLOBS, carries a small grey dot. The PIPE and GLOBS axis labels carry a teal tick.
- **Tree minimap:** two lit tiles, labelled Globs and adr/flow.
- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
