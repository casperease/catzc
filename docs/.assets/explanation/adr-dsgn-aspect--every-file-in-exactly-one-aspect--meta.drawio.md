# docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md

`Every module file is in exactly one aspect: the diagram described`

```text
A 1572 x 622 diagram, read left to right through three column bands.
Glyphs: 1 code unit (slate), 2 named sets (mauve), 2 ADR-only; 4 edges; 5 markers.
Sidebar: axis minimap (main cell DSGN x BUILD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/every-file-in-exactly-one-aspect.md).

## At a glance

A 1572 × 622 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
column bands, labelled FOLDER, FIRST MATCH and LOCKS. It holds five glyphs (one code unit, two named sets and two ADR-only) joined by four
edges in two rows, with five markers and a legend panel along the bottom. The eye lands first on the tall code unit filling FOLDER.

## Reading path

1. Marker 1, FOLDER: the tall code unit Module folder.
2. Right along the top thick edge to marker 2, FIRST MATCH, top: the named set live; then along a dashed edge to marker 4, LOCKS, top: the
   ADR-only glyph live lock.
3. Right along the bottom thick edge to marker 3, FIRST MATCH, bottom: the named set tests; then along a dashed edge to marker 5, LOCKS,
   bottom: the ADR-only glyph tests lock.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                |
| --------------------- | ----- | ---------------------------------------------------- |
| code unit             | 1     | Module folder (FOLDER, full height)                  |
| named set             | 2     | live (FIRST MATCH, top), tests (FIRST MATCH, bottom) |
| ADR-only              | 2     | live lock (LOCKS, top), tests lock (LOCKS, bottom)   |

The code unit is slate and the named sets are mauve, both with white names; the ADR-only glyphs are dashed white boxes.

## Edges

| Edge kind              | Count | From → to                                   |
| ---------------------- | ----- | ------------------------------------------- |
| thick (to a named set) | 2     | Module folder → live, Module folder → tests |
| ADR-only               | 2     | live → live lock, tests → tests lock        |

All four edges are straight and horizontal, pointing right, two per row. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                             |
| ----------------- | ---------------------------------- |
| slate rounded box | code unit                          |
| mauve rounded box | named set                          |
| dashed white box  | ADR-only                           |
| thick arrow       | thick: to a named set, first match |
| dashed arrow      | ADR-only (no code)                 |
| dark disc `1`     | marker: a Walkthrough step         |

## Sidebar

- **Axis minimap:** the main cell is DSGN × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Two touched cells, AUTO
  × CONFIG and AUTO × GLOBS, carry a small grey dot. The DSGN and BUILD axis labels carry a purple tick.
- **Tree minimap:** three lit tiles, labelled Globs, Variants and adr/dsgn (the ADR file framed in dark ink).
- **Lens badge:** META, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
