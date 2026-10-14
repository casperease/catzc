# docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md

`The namer looks up, forms, checks and renders in order: the diagram described`

```text
A 1572 x 820 diagram, read top to bottom down one column.
Glyphs: 6 code units (slate), 1 gate, 1 result, 2 failures; 7 flow edges, 5 failure paths; 10 markers.
Sidebar: axis minimap (main cell CLOUD x DEPLOY), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/azure/lookup-form-check-render-in-order.md).

## At a glance

A 1572 × 820 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one column
of glyphs: two code units, then a band labelled GUARDED holding four more code units, then a gate and a result. Two failures stand to the
right: a tall one beside the band and a short one beside the gate. Seven flow edges run down the column and five failure paths run across to
the right. Ten markers and a legend panel complete the drawing. The eye lands first on the tall red failure beside the band.

## Reading path

1. Markers 1 and 2, top of the column: the code units Deploy-Bicep and Get-BicepResourceName.
2. Markers 3 to 6, inside the GUARDED band, top to bottom: the code units lookup, omit + form, format checks and render.
3. Marker 7, right of the band: the failure guard throws, which a red edge from each of the four band steps enters.
4. Marker 8, below the band: the gate -gt limit?.
5. Marker 9, right of the gate: the failure limit throw.
6. Marker 10, below the gate: the result return $name.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                          |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| code unit             | 6     | Deploy-Bicep, Get-BicepResourceName (above the band); lookup, omit + form, format checks, render (in the band) |
| gate                  | 1     | -gt limit? (below the band)                                                                                    |
| result                | 1     | return $name (bottom of the column)                                                                            |
| failure               | 2     | guard throws (tall, right of the band), limit throw (right of the gate)                                        |

Code units are slate with white names; the gate is grey with a thick rim.

## Edges

| Edge kind    | Count | From → to                                                                                                        |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------- |
| flow         | 7     | Deploy-Bicep → Get-BicepResourceName → lookup → omit + form → format checks → render → -gt limit? → return $name |
| failure path | 5     | lookup, omit + form, format checks, render → guard throws; -gt limit? → limit throw                              |

Every edge is straight; the flow edges are vertical and the failure paths horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                         |
| ----------------------- | ------------------------------ |
| slate rounded box       | code unit                      |
| grey rhombus, thick rim | gate                           |
| green rounded box       | result                         |
| red rounded box         | failure                        |
| grey arrow              | flow: calls, in code order     |
| red arrow               | failure path                   |
| dark disc `1`           | marker: a Walkthrough step     |
| grey band               | band: steps whose guards throw |

## Sidebar

- **Axis minimap:** the main cell is CLOUD × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. No other cell is
  touched. The CLOUD and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** two lit tiles, labelled Az.Templates and adr/azure. The adr/azure file is framed in dark ink as an ADR file.
- **Lens badge:** IMPL, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
