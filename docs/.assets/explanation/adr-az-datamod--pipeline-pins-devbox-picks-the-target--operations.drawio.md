---
catzc:
  derived:
    path: docs/.assets/explanation/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.md
    kind: asset-description
    body_sha: "6764f10936d7"
    adrs: []
    links:
      - docs/.assets/explanation/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png
      - docs/explanation/azure/pipeline-pins-devbox-picks-the-target.md
---

# A pipeline pins, a devbox picks the target: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 external tools (neutral), 1 code unit (slate), 1 result, 3 failures; 3 flow edges, 1 failure path; 1 frame; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/azure/pipeline-pins-devbox-picks-the-target.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, `ENTRY`, `COMMAND` and `OUTCOME`. It holds seven glyphs, two external tools, one code unit, one result and three failures, joined by
three flow edges and one failure path, with seven markers and a legend panel along the bottom. The code unit in the command band is tall,
spanning both entry rows; a frame in the outcome band holds the three failures stacked in a column. The eye lands first on that tall slate
code unit in the middle.

## Reading path

1. Marker 1, entry band, upper row: the external tool service connection; below it, marker 2: the external tool az account set.
2. Right along either flow edge into the command band, to marker 3: the tall code unit Deploy-Bicep.
3. Right along the upper flow edge into the outcome band, to marker 4: the result deployment context.
4. Right along the failure path into the frame, then top to bottom, markers 5, 6 and 7: the failures no assert in a pipeline, undeclared
   subscription and wrong subscription.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| external tool         | 2     | service connection (entry band, upper), az account set (entry band, lower)                        |
| code unit             | 1     | Deploy-Bicep (command band, tall)                                                                 |
| result                | 1     | deployment context (outcome band, top)                                                            |
| failure               | 3     | no assert in a pipeline, undeclared subscription, wrong subscription (outcome band, in the frame) |

External tools are neutral, the code unit slate, the result green and the failures red. The frame is chrome: no fill and a thin
band-coloured rim.

## Edges

| Edge kind                 | Count | From → to                                                                                           |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 3     | service connection → Deploy-Bicep; az account set → Deploy-Bicep; Deploy-Bicep → deployment context |
| failure path              | 1     | Deploy-Bicep → the frame of three failures                                                          |

Every edge is horizontal; the two entry edges enter the tall code unit at two heights, and the two outcome edges leave it at two heights.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch             | Phrase                     |
| ------------------ | -------------------------- |
| neutral square box | external tool              |
| slate rounded box  | code unit                  |
| green rounded box  | result                     |
| red rounded box    | failure                    |
| thin arrow         | flow: feeds the next step  |
| red arrow          | failure path               |
| light disc `1`     | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps sit above it, and the map key below it names the four swatches.
