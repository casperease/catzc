---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--every-doubt-fails-open-to-proceed--meta.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "2bc46fc32fea"
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--every-doubt-fails-open-to-proceed--meta.drawio.png
      - docs/explanation/flow/every-doubt-fails-open-to-proceed.md
---

# Every doubt fails open to proceed: the diagram described

```text
A 1572 x 640 diagram, read top to bottom through three bands.
Glyphs: 1 store (slate), 1 gate, 2 results, 1 failure; 3 flow edges, 1 failure path; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-globs--every-doubt-fails-open-to-proceed--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/every-doubt-fails-open-to-proceed.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `GIT`, `THE CHECK` and `THE ANSWER`. It holds five glyphs, a store, a gate, two results and a failure, joined by
three flow edges and one failure path, with five markers and a legend panel along the bottom. The eye lands first on the gate rhombus in the
middle band, the only glyph with a thick rim.

## Reading path

1. Marker 1, `GIT` band: the store git at real refs, centred.
2. Down the flow edge to marker 2, `THE CHECK` band: the gate is this unit touched?
3. Right along the failure path to marker 5, same band: the failure a typo throws.
4. Down the two flow edges that leave the gate, marker 3 beside the left one and marker 4 beside the right one, to `THE ANSWER` band: the
   results stop and proceed.

## Glyphs

| Glyph (legend phrase) | Count | Where                                          |
| --------------------- | ----- | ---------------------------------------------- |
| store                 | 1     | git at real refs (`GIT`)                       |
| gate                  | 1     | is this unit touched? (`THE CHECK`), 3 px rim  |
| result                | 2     | stop and proceed (`THE ANSWER`), side by side  |
| failure               | 1     | a typo throws (`THE CHECK`, right of the gate) |

The store is slate with a white name, the gate a neutral rhombus, the results green and the failure the only red.

## Edges

| Edge kind                 | Count | From → to                                            |
| ------------------------- | ----- | ---------------------------------------------------- |
| flow: feeds the next step | 3     | git at real refs → gate; gate → stop; gate → proceed |
| failure path              | 1     | gate → a typo throws                                 |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate cylinder    | store                      |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `META`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, lit ADR file, idle.
