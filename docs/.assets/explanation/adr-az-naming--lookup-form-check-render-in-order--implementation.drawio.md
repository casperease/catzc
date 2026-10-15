# docs/.assets/explanation/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.md

`The namer looks up, forms, checks and renders in order: the diagram described`

```text
A 1572 x 820 diagram, read top to bottom down one column.
Glyphs: 6 code units (slate), 1 gate, 1 result, 2 failures; 7 flow edges, 5 failure paths; 10 markers.
Sidebar: world-map grid (4 lit cells), tree (7 lit groups), value-chain map (1 lit cell), map key.
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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md),
[tree](adr-az-naming--lookup-form-check-render-in-order--implementation.tree.md) and
[value-chain map](adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-AZ-NAMING); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-AZ-NAMING);
  `automation × .ps1` (7 files: 7 cite ADR-AZ-NAMING); `automation × .yml` (4 files: 4 cite ADR-AZ-NAMING); `docs × .md` (4 files: 3 cite
  ADR-AZ-NAMING; 1 is the ADR file of ADR-AZ-NAMING).
- **Tree** (the repository's files): 7 lit groups, `Az.Templates` (7 files); `Azure` (4 files); `Docs` (2 files); `adr/azure` (2 files);
  `Variants` (1 file); `adr/*` (1 file); `docs` (1 file). The ADR file `docs/adr/azure/azure-naming-standard.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `CLOUD × DEPLOY`, because ADR-AZ-NAMING: its
  ADR domain `azure` sits on the CLOUD row (ADR-DSGN-TRACK#14), and deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
