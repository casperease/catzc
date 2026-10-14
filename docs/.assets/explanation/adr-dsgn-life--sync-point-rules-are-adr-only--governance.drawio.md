# docs/.assets/explanation/adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.md

`Only BVT is gated; the sync point is ADR-only: the diagram described`

```text
A 1572 x 690 diagram, read top to bottom through three bands, with one row of hexagons and a gate in the middle band.
Glyphs: 1 ADR-only box, 5 environments (ADR-only, framed), 1 gate, 5 commits; 6 ADR-only flow edges, 1 failure path.
Marks: 11 rule chips, 8 markers. Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge GOV, map key.
```

This describes what the [diagram](adr-dsgn-life--sync-point-rules-are-adr-only--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/sync-point-rules-are-adr-only.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands run top to bottom,
labelled EXTERNAL, PROMOTION LADDER and TIP OF MAIN. The drawing holds one ADR-only box, five environment hexagons (each white, dashed,
inside a dashed frame), one gate with a thick solid rim, and five commits, joined by six dashed flow edges and one dashed failure path.
Eleven rule chips sit beside the glyphs, eight markers number them, and a legend panel runs along the bottom. The eye lands first on the one
solid shape, the gate at the right end of the ladder.

## Reading path

1. Marker 1, EXTERNAL band: the ADR-only box upstream integrator, with chips `L6` and `L7` to its right.
2. Down its dashed edge into the light-blue commit `6` inside main-UAT.
3. Markers 2 to 6, PROMOTION LADDER band, left to right: production (green `4`, chip `L5`), pre-prod (green, no digit, chip `F11`),
   release-uat (light-green `5`, chip `F9`), main-UAT (light-blue `6`, chips `F9` and `L6`), on-demand (L3) (empty, chip `F5`), each
   joined to the next by a short dashed arrow pointing right.
4. Marker 7, on the gate ci-automation at the right end of the ladder, chip `L2` at its lower right.
5. Down the red dashed failure path from main-UAT to marker 8, TIP OF MAIN band: the blue commit `10`, named dirty HEAD, chips `L7` and
   `L8`.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                                                                  |
| ------------------------------ | ----- | ------------------------------------------------------------------------------------------------------ |
| ADR-only (box)                 | 1     | upstream integrator, EXTERNAL band, centred above main-UAT                                             |
| environment (ADR-only, framed) | 5     | production, pre-prod, release-uat, main-UAT, on-demand (L3), PROMOTION LADDER band                     |
| gate                           | 1     | ci-automation, PROMOTION LADDER band, right end; neutral grey, 3 px rim                                |
| commit (locked palette)        | 5     | green `4`, green (no digit), light-green `5`, light-blue `6` inside hexagons; blue `10` in TIP OF MAIN |

No glyph on this diagram is structural: the environments and the gate are neutral and every commit keeps its locked colour.

## Edges

| Edge kind                            | Count | From → to                                                                                                                                                   |
| ------------------------------------ | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: takes its commit from (dashed) | 6     | upstream integrator → `6`; production → pre-prod; pre-prod → release-uat; release-uat → main-UAT; main-UAT → on-demand (L3); on-demand (L3) → ci-automation |
| failure path (red, dashed)           | 1     | main-UAT → `10`                                                                                                                                             |

Every edge is straight; the five in the ladder are horizontal and the other two vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                        |
| ----------------------- | --------------------------------------------- |
| white hexagon           | environment: its occupant inside              |
| grey rhombus, thick rim | gate                                          |
| four commit dots        | commit (locked palette)                       |
| dashed white box        | ADR-only (no code): glyph or edge             |
| dashed grey arrow       | flow: takes its commit from                   |
| dashed red arrow        | failure path                                  |
| white chip `L6`         | rule chip: L = ADR-DSGN-LIFE, F = ADR-FLOW-CD |
| dark disc `1`           | marker: a Walkthrough step                    |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Four touched cells carry
  a small grey dot: AUTO × LOAD, AUTO × BUILD, PIPE × BUILD and PIPE × DEPLOY.
- **Tree minimap:** lit tiles labelled ModuleSystem, Docs, `adr/flow`, `pipelines` and `.github`; the `.github` label is cut at the image
  edge.
- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
