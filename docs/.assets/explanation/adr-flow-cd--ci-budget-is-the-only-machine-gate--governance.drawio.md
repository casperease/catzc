# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-machine-gate--governance.drawio.md

`The CI budget is the only machine gate: the diagram described`

```text
A 1572 x 600 diagram, read left to right along a FLOW band, with a CHECKS band below it.
Glyphs: 4 runners (2 slate, 2 ADR-only), 3 gates (1 solid, 2 ADR-only), 1 actor; 7 rule chips; 1 flow and 1 ADR-only edge; 8 markers.
Sidebar: axis minimap (main cell PIPE x DEPLOY), tree minimap, lens badge GOV, map key.
```

This describes what the [diagram](adr-flow-cd--ci-budget-is-the-only-machine-gate--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/ci-budget-is-the-only-machine-gate.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a top band
labelled FLOW, with a second full-width band labelled CHECKS below it. Three span bars sit above the bands: CD and DEPLOY on the upper row,
CI on the lower row. It holds eight glyphs (four runners, three gates and one actor), seven rule chips, eight markers, and a legend panel
along the bottom. The glyphs in the FLOW band stand in one row with no edges between them. The eye lands first on the two slate runners at
the left of the FLOW band.

## Reading path

1. Marker 1, FLOW band: the runner CI inner loop, solid chip `#2`.
2. Marker 2, CHECKS band: the gate machine gate, solid chip `#13`, with its edge up into CI inner loop.
3. Marker 3, FLOW band: the runner CD, dashed chip `#5`.
4. Marker 4: the gate RC, thin dashed rim, in a dashed frame, dashed chip `#9`.
5. Marker 5: the dashed white runner DEPLOY-Non-Prod, dashed chip `#11`.
6. Marker 6: the gate RBC, thin dashed rim, in a dashed frame, dashed chip `#9`.
7. Marker 7: the dashed white runner DEPLOY-Prod, dashed chip `#12`.
8. Marker 8, CHECKS band: the actor reviewer, with a dashed edge up to the FLOW band.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------- |
| runner                | 4     | CI inner loop and CD (solid, slate), DEPLOY-Non-Prod and DEPLOY-Prod (ADR-only: dashed, white), in FLOW              |
| gate                  | 3     | machine gate (CHECKS, left, solid grey, 3 px rim); RC and RBC (FLOW, ADR-only: white, thin dashed rim, dashed frame) |
| actor                 | 1     | reviewer (CHECKS, centre)                                                                                            |

## Edges

| Edge kind | Count | From → to                                        |
| --------- | ----- | ------------------------------------------------ |
| flow      | 1     | machine gate → CI inner loop (upward)            |
| ADR-only  | 1     | reviewer → the FLOW band's lower border (upward) |

Both edges are straight and vertical. Seven rule chips sit on the upper right of their glyphs: `#2` and `#13` solid; `#5`, `#9`, `#11`, `#9`
and `#12` dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                         |
| ----------------------- | ---------------------------------------------- |
| slate pill              | runner                                         |
| grey rhombus, thick rim | gate                                           |
| white circle            | actor                                          |
| white chip `#5`         | rule chip: ADR-FLOW-CD rule                    |
| solid arrow             | flow: checks                                   |
| dashed arrow            | ADR-only (no code): dashed line, frame or chip |
| span bar                | span bar: stages over bands                    |
| dark disc `1`           | marker: a Walkthrough step                     |

## Sidebar

- **Axis minimap:** the main cell is PIPE × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Two touched cells, AUTO
  × BUILD and PIPE × BUILD, carry a small grey dot.
- **Tree minimap:** four lit tiles, labelled QualityGates, Docs, adr/flow and pipelines.
- **Lens badge:** GOV, with "Supports ADR-FLOW-CD · ADR-FLOW-CD-TYPE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
