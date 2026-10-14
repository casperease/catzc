# docs/.assets/explanation/adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.md

`One commit, one verified, immutable package: the diagram described`

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 named set (mauve), 1 code unit (slate), 1 gate, 2 results; 5 flow edges; 6 markers.
Sidebar: axis minimap (main cell AUTO x BUILD), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-auto-bundle--one-commit-one-immutable-package--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/one-commit-one-immutable-package.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands of equal height, labelled SOURCE, BUILD, BUNDLE and CODE ROOTS. Five glyphs (one named set, one code unit, one gate and two results)
sit on one horizontal line through the middle of the bands, joined by four flow edges, and one more flow edge returns over the top of the
bands from the last glyph to the gate. Six markers number them, and a legend panel runs along the bottom. The eye lands first on the grey
gate rhombus in the BUILD band, the only diamond on the line.

## Reading path

1. Marker 1, SOURCE band: the named set Selected modules.
2. Along the line to marker 2, BUILD band: the code unit One build.
3. Marker 3, BUILD band: the gate Integrity check.
4. Marker 4, BUNDLE band: the result Temporary build.
5. Marker 5, CODE ROOTS band: the result Installed · saved.
6. Marker 6, just below the returning edge above the bands, which runs from Installed · saved back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                              |
| --------------------- | ----- | ------------------------------------------------------------------ |
| named set             | 1     | Selected modules (SOURCE band)                                     |
| code unit             | 1     | One build (BUILD band, left)                                       |
| gate                  | 1     | Integrity check (BUILD band, right), a rhombus with a 3 px rim     |
| result                | 2     | Temporary build (BUNDLE band), Installed · saved (CODE ROOTS band) |

The named set is mauve and the code unit slate, both with white names; the gate is grey and the results are green.

## Edges

| Edge kind | Count | From → to                                                                                                                 |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Selected modules → One build → Integrity check → Temporary build → Installed · saved; Installed · saved → Integrity check |

The four edges on the line are short, straight and horizontal. The fifth leaves the top of Installed · saved, runs left above the bands in
one straight horizontal stretch, and drops into the top point of the gate; it is drawn as three straight segments with one arrowhead.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| mauve rounded box       | named set                         |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| grey arrow              | flow: feeds or runs the next step |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

- **Axis minimap:** the main cell is AUTO × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Two touched cells, DSGN
  × LOAD and AUTO × LOAD, carry a small grey dot. The AUTO and BUILD axis labels carry a purple tick.
- **Tree minimap:** four lit tiles, labelled .internal, Exporter, adr/auto and adr/dsgn; the ADR files are framed in dark ink.
- **Lens badge:** META, with "Supports ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE" beneath it on two lines.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
