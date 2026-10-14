# docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md

`Where the code loads from decides the run mode: the diagram described`

```text
A 1572 x 630 diagram, read top to bottom through four bands.
Glyphs: 2 stores (slate), 1 code unit (slate), 1 named set (mauve); 2 flow edges, 1 thick edge; 5 markers.
Sidebar: axis minimap (main cell DSGN x LOAD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/where-code-loads-from-decides-the-mode.md).

## At a glance

A 1572 × 630 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. Two bands sit
side by side at the top, SOURCE (narrow, left) and BUILD (wide, right); below them run two full-width bands, ONE IMPORTER and SAME MODULES.
It holds four glyphs, two stores, one code unit and one named set, joined by three edges, with five markers and a legend panel along the
bottom. The eye lands first on the full-width code unit in the ONE IMPORTER band, which both stores point down into.

## Reading path

1. Marker 1, SOURCE band: the store "the repository".
2. Marker 2, BUILD band: the wide store "a built package".
3. Down the two edges to marker 3, the code unit "one importer".
4. Marker 5, touching the thick edge that leaves the code unit, and down to marker 4, the named set "same modules".

## Glyphs

| Glyph (legend phrase) | Count | Where                                            |
| --------------------- | ----- | ------------------------------------------------ |
| store                 | 2     | the repository (SOURCE), a built package (BUILD) |
| code unit             | 1     | one importer (ONE IMPORTER, full width)          |
| named set             | 1     | same modules (SAME MODULES, centred)             |

Stores and the code unit are slate and the named set is mauve, all with white names.

## Edges

| Edge kind             | Count | From → to                                                     |
| --------------------- | ----- | ------------------------------------------------------------- |
| flow                  | 2     | the repository → one importer; a built package → one importer |
| thick, to a named set | 1     | one importer → same modules (marker 5)                        |

Every edge is straight and vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                     |
| ----------------- | ------------------------------------------ |
| slate cylinder    | store: a code root                         |
| slate rounded box | code unit                                  |
| mauve rounded box | named set                                  |
| thin arrow        | flow: the code loads into                  |
| thick arrow       | thick: the code loads into, to a named set |
| dark disc `1`     | marker: a Walkthrough step                 |
| grey band         | band: a mode or a stage                    |

## Sidebar

- **Axis minimap:** the main cell is DSGN × LOAD, framed and filled in the LOAD blue with the you-are-here dot. Three touched cells, AUTO ×
  LOAD, AUTO × BUILD and AUTO × ACCESS, carry a small grey dot. The DSGN and LOAD axis labels carry a blue tick.
- **Tree minimap:** lit tiles labelled QualityGates, .internal, Repository, Exporter, adr/dsgn and (root). The adr/dsgn file is framed in
  dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
