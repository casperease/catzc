# docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md

`Build, then place with one command: the diagram described`

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 5 code units (slate), 1 gate, 1 result, 1 failure; 4 flow edges, 1 failure path; 8 markers.
Sidebar: axis minimap (main cell AUTO x BUILD), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-auto-bundle--build-then-place-with-one-command--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/build-then-place-with-one-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `TARGETS`. It holds eight glyphs (five code units, one gate, one failure and one result)
joined by four flow edges and one failure path, with eight markers and a legend panel along the bottom. Four glyphs sit on one horizontal
line; the failure hangs below the gate, and a thin grey frame in the TARGETS band holds three code units stacked one above the other,
entered by a single edge. The eye lands first on the red failure below the grey rhombus (the gate).

## Reading path

1. Marker 1, SOURCE band: the code unit . ./importer.ps1.
2. Marker 2, BUILD band: the code unit Build-Modules.
3. Marker 3, BUILD band: the gate Assert-CatzcBundle.
4. Marker 4, below it: the failure Catzc build … is invalid, reached by the red failure path from the bottom point of the gate.
5. Marker 5, BUNDLE band: the result Built Catzc 6.6.666.
6. Markers 6, 7 and 8, TARGETS band, top to bottom inside the frame: the code units Install-Catzc -Scope, Export-Catzc -Root and
   Export-Catzc -To nuget.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | . ./importer.ps1 (SOURCE band), Build-Modules (BUILD band), Install-Catzc -Scope, Export-Catzc -Root, Export-Catzc -To nuget (TARGETS band, in the frame) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                                                                                         |
| failure               | 1     | Catzc build … is invalid (BUILD band, below the gate)                                                                                                     |
| result                | 1     | Built Catzc 6.6.666 (BUNDLE band)                                                                                                                         |

The code units are slate with white names; the gate is grey, the result green and the failure red.

## Edges

| Edge kind    | Count | From → to                                                                           |
| ------------ | ----- | ----------------------------------------------------------------------------------- |
| flow         | 4     | . ./importer.ps1 → Build-Modules → Assert-CatzcBundle → Built Catzc 6.6.666 → frame |
| failure path | 1     | Assert-CatzcBundle → Catzc build … is invalid                                       |

Every edge is short and straight: four horizontal on the line, and one red vertical below the gate. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| red rounded box         | failure                           |
| grey arrow              | flow: feeds or runs the next step |
| red arrow               | failure path                      |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

- **Axis minimap:** the main cell is AUTO × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Three touched cells,
  AUTO × LOAD, AUTO × CONFIG and PIPE × BUILD, carry a small grey dot. The AUTO and BUILD axis labels carry a purple tick.
- **Tree minimap:** lit tiles labelled .internal, RootConfig, Exporter and adr/auto, and a .github tile cut at the image edge; the ADR file
  is framed in dark ink.
- **Lens badge:** OPS, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
