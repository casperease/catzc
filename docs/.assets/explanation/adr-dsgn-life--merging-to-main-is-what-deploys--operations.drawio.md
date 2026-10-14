# docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md

`Merging to main is what deploys: the diagram described`

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 2 commits, 3 runners (slate), 1 environment, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/merging-to-main-is-what-deploys.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING. It holds seven glyphs: two commits, three runners, one
environment and one ADR-only glyph. The top row runs from the brown commit to the grey one, then to a runner and a wide environment hexagon.
From the brown commit a vertical line drops through the TOPIC band and branches right three times: two solid branches to runners and a
dashed branch to the ADR-only pill. Two span bars sit inside the bands: CI over the first branch's runner, and CD over the AFTER LANDING
row. Six markers number the reading order.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled push topic, open PR.
2. Down the vertical line and right to marker 2, OUT-OF-BAND band: the runner ADO PR build, under the CI span bar.
3. Marker 3: the runner Release: Run workflow.
4. Down the dashed leg and right to marker 4: the dashed white pill, deploy topic.
5. Back to the top row, along the flow edge to marker 5, MAIN band: the grey commit, complete PR.
6. Right to marker 6, AFTER LANDING band, under the CD span bar: the runner ADO CD run, then the environment `<Customer>-<env>[-<slot>]`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------- |
| commit                | 2     | brown push topic, open PR (TOPIC), grey complete PR (MAIN)                       |
| runner                | 3     | ADO PR build and Release: Run workflow (OUT-OF-BAND), ADO CD run (AFTER LANDING) |
| environment           | 1     | `<Customer>-<env>[-<slot>]` (AFTER LANDING, top row), empty                      |
| ADR-only              | 1     | deploy topic (OUT-OF-BAND, bottom row), a dashed white pill                      |

Runners are slate pills with white names; the environment is neutral grey; the commits keep the locked commit palette.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                               |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | push topic, open PR → complete PR, complete PR → ADO CD run, ADO CD run → environment (top row); push topic, open PR → ADO PR build and → Release: Run workflow, both from a vertical trunk drawn as two leg cells with no arrowhead and two right legs with arrowheads |
| ADR-only  | 1     | push topic, open PR → deploy topic (a dashed down leg with no arrowhead from the trunk's lower bend point, then a dashed right leg with the arrowhead)                                                                                                                  |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                            |
| --------------------------------- | --------------------------------- |
| brown and grey discs              | commit (locked palette)           |
| slate pill                        | runner: a run you start or see    |
| grey hexagon                      | environment                       |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge |
| thin arrow                        | flow: starts a run                |
| dark disc `1`                     | marker: a Walkthrough step        |
| crossbar                          | span bar: stages over bands       |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Two touched cells, PIPE
  × BUILD and PIPE × DEPLOY, carry a small grey dot.
- **Tree minimap:** lit tiles labelled adr/dsgn and pipelines, and a .github label cut at the bottom edge of the image; the adr/dsgn files
  are framed in dark ink as ADR files.
- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE · ADR-DSGN-VISUAL" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
