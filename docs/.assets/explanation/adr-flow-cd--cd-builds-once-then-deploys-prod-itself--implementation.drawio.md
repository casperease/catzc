# docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md

`The customer CD pipeline builds once, then deploys prod itself: the diagram described`

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 runners (slate), 3 results, 2 environments; 10 flow edges; 6 markers.
Sidebar: axis minimap (main cell PIPE x DEPLOY), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled CI STAGE, DEPLOY STAGES and TARGETS. Two span bars sit above them: CD over the first two bands on the upper
row, CI over the first band on the lower row. It holds nine glyphs (four runners, three results and two environments), six markers, and a
legend panel along the bottom. The eye lands first on the tall slate capsule Build-Bicep at the far left.

## Reading path

1. Marker 1, CI STAGE: the runner Build-Bicep, a tall capsule.
2. Marker 2, CI STAGE: the first of three stacked results, foundation, then discovery and expedition below it.
3. Marker 3, DEPLOY STAGES: the runner Deploy_Foundation, the top of three stacked runners.
4. Marker 4, beside the edge from Deploy_Foundation down to Deploy_Discovery.
5. Marker 5, TARGETS: the environment nsub · dev · test.
6. Marker 6, TARGETS: the environment psub · prod.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                         |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| runner                | 4     | Build-Bicep (CI STAGE, tall), Deploy_Foundation, Deploy_Discovery, Deploy_Expedition (DEPLOY STAGES, stacked) |
| result                | 3     | foundation, discovery, expedition (CI STAGE, stacked)                                                         |
| environment           | 2     | nsub · dev · test (TARGETS, upper), psub · prod (TARGETS, lower)                                              |

The runners are slate with white names; the results are light green; the environments are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                       |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 10    | Build-Bicep → each of the three results; each result → the runner beside it; Deploy_Foundation → Deploy_Discovery → Deploy_Expedition; the DEPLOY STAGES band's right border → each environment |

Every edge is straight. Six run horizontally in three rows, two run vertically between the stacked deploy runners, and two leave the right
border of the DEPLOY STAGES band, one at the height of each environment. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| green rounded box | result                      |
| grey hexagon      | environment                 |
| solid arrow       | flow: next in code order    |
| span bar          | span bar: stages over bands |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

- **Axis minimap:** the main cell is PIPE × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Two touched cells, PIPE
  × BUILD and CLOUD × DEPLOY, carry a small grey dot.
- **Tree minimap:** three lit tiles, labelled Az.Templates, adr/flow and pipelines.
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
