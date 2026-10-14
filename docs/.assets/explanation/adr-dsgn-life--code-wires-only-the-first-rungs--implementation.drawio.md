# docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md

`The pipelines wire only topic, landed and BVT: the diagram described`

```text
A 1572 x 600 diagram, read left to right through three bands standing side by side.
Glyphs: 3 commits, 8 runners (slate), 1 ADR-only runner; 8 flow edges, 1 ADR-only edge; 8 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/code-wires-only-the-first-rungs.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands standing side by side as columns, labelled PRE-COMMIT, POST-COMMIT and DEPLOY STAGES. A narrow band labelled BVT sits inside
POST-COMMIT and holds three runners stacked top to bottom. Two span bars run above: CI over PRE-COMMIT and POST-COMMIT up to the BVT band,
and CD from the dashed runner to the right edge. The eye lands first on the three wide slate runners stacked in DEPLOY STAGES.

## Reading path

1. Marker 1, PRE-COMMIT band: the brown commit `topic`, then the runner `pr: [main]`.
2. Marker 2, POST-COMMIT band: the grey commit `landed`, then the runner `trigger: [main]`, whose arrow enters the BVT band.
3. Markers 3, 4 and 5, BVT band, top to bottom: the runners `CD stage CI`, `ci-automation` and `ci-infrastructure`.
4. Right from `CD stage CI` to the yellow commit `BVT`; marker 6 below it, on the dashed runner `L3 run`.
5. Right from the yellow commit to marker 7, DEPLOY STAGES band: the runner `Deploy_Foundation`, then down to marker 8, `Deploy_Discovery`,
   and down again to `Deploy_Expedition`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| commit                | 3     | brown `topic` (PRE-COMMIT), grey `landed` and yellow `BVT` (POST-COMMIT); each name sits above its commit |
| runner                | 8     | `pr: [main]`, `trigger: [main]`, three in the BVT band, three in DEPLOY STAGES                            |
| ADR-only              | 1     | `L3 run`, a white dashed runner below the yellow commit                                                   |

The runners are slate with white names, so none shares the yellow of the BVT commit beside them.

## Edges

| Edge kind | Count | From → to                                                                                                                                        |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 8     | topic → pr: [main] → landed → trigger: [main] → BVT band; CD stage CI → yellow commit → Deploy_Foundation → Deploy_Discovery → Deploy_Expedition |
| ADR-only  | 1     | yellow commit → L3 run                                                                                                                           |

The row edges are straight and horizontal; the deploy edges and the ADR-only edge run straight down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                         | Phrase                       |
| ------------------------------ | ---------------------------- |
| three small commits            | commit (locked palette)      |
| slate pill                     | runner                       |
| white dashed box, dashed arrow | ADR-only (no code)           |
| thin arrow                     | flow: runs next              |
| span bar                       | span bar: stages over bands  |
| grey band                      | band: trigger or stage group |
| dark disc `1`                  | marker: a Walkthrough step   |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Four touched cells carry
  a small grey dot: AUTO × BUILD, PIPE × BUILD, PIPE × DEPLOY and CLOUD × DEPLOY.
- **Tree minimap:** lit tiles in the groups labelled QualityGates, Az.Templates, Az.DevOps.BuildValidation, adr/dsgn and pipelines.
- **Lens badge:** IMPL, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
