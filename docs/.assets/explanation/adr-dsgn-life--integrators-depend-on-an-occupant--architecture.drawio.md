# docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md

`Integrators depend on the main-UAT occupant: the diagram described`

```text
A 1572 x 670 diagram, read top to bottom through three bands, with one row of hexagons in the middle band.
Glyphs: 1 ADR-only box, 4 environments (ADR-only, framed), 5 commits; 4 ADR-only flow edges, 1 failure path; 6 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/integrators-depend-on-an-occupant.md).

## At a glance

A 1572 × 670 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands run top to bottom,
labelled EXTERNAL, PROMOTION LADDER and TIP OF MAIN. The drawing holds one ADR-only box, four environment hexagons (each white, dashed,
inside a dashed frame) and five commits, joined by four dashed flow edges and one dashed failure path, with six markers and a legend panel
along the bottom. The eye lands first on the row of four hexagons in the middle band.

## Reading path

1. Marker 1, EXTERNAL band: the ADR-only box upstream integrator, above the right-hand hexagon.
2. Down its dashed edge into the light-blue commit `6` inside main-UAT.
3. Markers 2 to 5, PROMOTION LADDER band, left to right: production (green `4`), pre-prod (green, no digit), release-uat (light-green `5`),
   main-UAT (light-blue `6`), each joined to the next by a short dashed arrow pointing right.
4. Down the red dashed failure path from main-UAT to marker 6, TIP OF MAIN band: the blue commit `10`, named dirty HEAD.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                                                    |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------- |
| ADR-only (box)                 | 1     | upstream integrator, EXTERNAL band, centred above main-UAT                               |
| environment (ADR-only, framed) | 4     | production, pre-prod, release-uat, main-UAT, PROMOTION LADDER band, left to right        |
| commit (locked palette)        | 5     | green `4`, green (no digit), light-green `5`, light-blue `6` inside the hexagons; blue `10` in TIP OF MAIN |

No glyph on this diagram is structural: the environments are neutral and every commit keeps its locked colour.

## Edges

| Edge kind                            | Count | From → to                                                                                        |
| ------------------------------------ | ----- | ------------------------------------------------------------------------------------------------ |
| flow: takes its commit from (dashed) | 4     | upstream integrator → `6`; production → pre-prod; pre-prod → release-uat; release-uat → main-UAT |
| failure path (red, dashed)           | 1     | main-UAT → `10`                                                                                  |

Every edge is straight; the three in the ladder are horizontal and the other two vertical. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| white hexagon     | environment: its occupant inside  |
| four commit dots  | commit (locked palette)           |
| dashed white box  | ADR-only (no code): glyph or edge |
| dashed grey arrow | flow: takes its commit from       |
| dashed red arrow  | failure path                      |
| dark disc `1`     | marker: a Walkthrough step        |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Two touched cells, PIPE
  × BUILD and PIPE × DEPLOY, carry a small grey dot. The DSGN and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** lit tiles in the `adr/flow`, `pipelines` and `.github` groups at the right edge; the `.github` label is cut at the image
  edge.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
