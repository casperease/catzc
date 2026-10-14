# docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md

`An engineer runs the tests and merges; pipelines do the rest: the diagram described`

```text
A 1572 x 600 diagram, read left to right along a top row, with failures in a band below.
Glyphs: 3 runners (slate), 1 gate, 1 ADR-only runner, 3 failures; 3 flow, 2 ADR-only, 3 failure-path edges; 8 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/engineer-merges-pipelines-do-the-rest.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two bands stand side by side on top, labelled
PERSON RUNS and PIPELINE RUNS, and one full-width band below, labelled ON FAILURE. Two span bars run above: CI over the gate and the first
pipeline runner, and CD over the dashed runner and the wide runner. The top row reads left to right; three red failure glyphs sit in the
bottom band, each straight below what raises it. The eye lands first on the wide slate runner at the right of the top row, then on the three
red boxes.

## Reading path

1. Marker 1, PERSON RUNS band: the runner `Test-Automation`.
2. Marker 2: the gate `merge the PR`.
3. Markers 3, 4 and 5, PIPELINE RUNS band, left to right: the runner `post-commit CI`, the dashed runner `L3 run`, and the wide runner
   `cd-shared · cd-<customer>`. A line also leaves the gate's top, runs right above the row, and drops into the wide runner.
4. Markers 6, 7 and 8, ON FAILURE band, left to right: the failures `PR blocked`, `red CI run` and `stage failed`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| runner                | 3     | `Test-Automation` (PERSON RUNS), `post-commit CI` and `cd-shared · cd-<customer>` (PIPELINE RUNS) |
| gate                  | 1     | `merge the PR`, PERSON RUNS, grey rhombus with a 3 px rim                                         |
| ADR-only              | 1     | `L3 run`, a white dashed runner, PIPELINE RUNS                                                    |
| failure               | 3     | `PR blocked`, `red CI run`, `stage failed`, ON FAILURE band                                       |

The runners are slate with white names; the gate is neutral grey.

## Edges

| Edge kind    | Count | From → to                                                                                          |
| ------------ | ----- | -------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → merge the PR → post-commit CI; merge the PR → cd-shared · cd-\<customer\>        |
| ADR-only     | 2     | post-commit CI → L3 run → cd-shared · cd-\<customer\>                                              |
| failure path | 3     | merge the PR → PR blocked; post-commit CI → red CI run; cd-shared · cd-\<customer\> → stage failed |

The flow edge from the gate to the wide runner is drawn in three straight segments: up from the gate's top, right above the row, and down
into the wide runner. The other edges are straight; the failure paths drop straight down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                         | Phrase                        |
| ------------------------------ | ----------------------------- |
| slate pill                     | runner                        |
| grey rhombus, 3 px rim         | gate                          |
| red rounded box                | failure: what the person sees |
| white dashed box, dashed arrow | ADR-only (no code)            |
| thin arrow                     | flow: runs next               |
| red arrow                      | failure path                  |
| dark disc `1`                  | marker: a Walkthrough step    |
| span bar                       | span bar: stages over bands   |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Three touched cells
  carry a small grey dot: PIPE × BUILD, PIPE × DEPLOY and CLOUD × DEPLOY.
- **Tree minimap:** lit tiles in the groups labelled Az.Templates, adr/flow, pipelines and .github.
- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
