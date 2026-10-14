# docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md

`The step is named after its command: the diagram described`

```text
A 1572 x 620 diagram, read left to right along one row, with drops below it.
Glyphs: 1 runner (slate), 3 results, 2 failures, 1 actor; 3 flow edges, 2 failure paths, 1 ADR-only edge; 7 markers.
Sidebar: axis minimap (main cell PIPE x LOAD), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/the-step-is-named-after-its-command.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
RUN above and DEVELOPER below. It holds seven glyphs (one runner, three results, two failures and one actor) joined by six edges, with seven
markers and a legend panel along the bottom. The eye lands first on the row of green boxes across the PIPELINE RUN band, with two red boxes
beneath it.

## Reading path

1. Marker 1, PIPELINE RUN band: the runner pipeline step, at the left edge.
2. Down the failure path to marker 3, the failure guard throw.
3. Right from the runner to marker 2, the result step label.
4. Right to marker 4, the result Invoke-Automation [Mode], then marker 5, the result echoed command.
5. Down the failure path to marker 6, the failure Write-Exception.
6. From step label, down the dashed edge to marker 7, DEVELOPER band: the actor developer.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------- |
| runner                | 1     | pipeline step (PIPELINE RUN band, top left)                                       |
| result                | 3     | step label, Invoke-Automation [Mode], echoed command (PIPELINE RUN band, top row) |
| failure               | 2     | guard throw (under pipeline step), Write-Exception (under echoed command)         |
| actor                 | 1     | developer (DEVELOPER band, under step label)                                      |

The runner is a slate pill with a white name; results are green and failures red.

## Edges

| Edge kind    | Count | From → to                                                              |
| ------------ | ----- | ---------------------------------------------------------------------- |
| flow         | 3     | pipeline step → step label → Invoke-Automation [Mode] → echoed command |
| failure path | 2     | pipeline step → guard throw, echoed command → Write-Exception          |
| ADR-only     | 1     | step label → developer                                                 |

The flow edges are horizontal along the top row; the two failure paths and the dashed edge are vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate pill        | runner                     |
| green rounded box | result                     |
| red rounded box   | failure                    |
| white circle      | actor                      |
| thin grey arrow   | flow: run order            |
| thin red arrow    | failure path               |
| dashed arrow      | ADR-only (no code)         |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is PIPE × LOAD, framed and filled in the LOAD indigo with the you-are-here dot. Three touched cells carry
  a small grey dot: PIPE × BUILD, AUTO × BUILD and AUTO × LOAD. The PIPE and LOAD axis labels carry an indigo tick.
- **Tree minimap:** lit tiles labelled Writers, adr/flow, pipelines and (root).
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
