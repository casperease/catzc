# docs/.assets/explanation/adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.md

`Deploying a topic commit and integrating it share only the topic commit: the diagram described`

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 1 gate, 1 environment, 1 ADR-only; 3 flow edges, 2 ADR-only edges; 6 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-dsgn-life--deploy-and-integrate-share-only-the-topic--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/design/deploy-and-integrate-share-only-the-topic.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds seven glyphs: four commits, one gate, one environment and one ADR-only glyph. A straight flow line runs across the
top row from the brown commit to the yellow one; a dashed path drops from the brown commit into the OUT-OF-BAND band. Six markers number the
reading order, and a legend panel runs along the bottom. The eye lands first on the long top line.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic commit above it.
2. Down the dashed edge and right to marker 2, OUT-OF-BAND band: the dashed white pill, workflow / pipeline.
3. Down the dashed edge to marker 3: the environment hexagon, with a small brown commit inside, above its name.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main.
5. Right to marker 5, AFTER LANDING band: the gate BVT, then on to the yellow commit labelled BVT-verified.
6. Marker 6, just above the top flow edge where it crosses the OUT-OF-BAND band, rim touching the line.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| commit                | 4     | brown topic commit (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 1     | BVT (AFTER LANDING, top row), 3 px rim                                                                                         |
| environment           | 1     | environment (OUT-OF-BAND, bottom)                                                                                              |
| ADR-only              | 1     | workflow / pipeline (OUT-OF-BAND, middle), a dashed white pill                                                                 |

The commits keep the locked commit palette; the gate and the environment are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                     |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | topic commit → main (marker 6), main → BVT, BVT → BVT-verified                                                                                                                                |
| ADR-only  | 2     | topic commit → workflow / pipeline (one dashed edge drawn as two cells: a down leg with no arrowhead to a bend point, then a right leg with the arrowhead), workflow / pipeline → environment |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                            |
| --------------------------------- | --------------------------------- |
| brown, grey and yellow discs      | commit (locked palette)           |
| grey rhombus with a thick rim     | gate                              |
| grey hexagon                      | environment: its occupant inside  |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge |
| thin arrow                        | flow: lands, then climbs          |
| dark disc `1`                     | marker: a Walkthrough step        |
| crossbar                          | span bar: stages over bands       |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. One touched cell, PIPE ×
  DEPLOY, carries a small grey dot.
- **Tree minimap:** two lit tiles, labelled adr/dsgn and pipelines; the adr/dsgn files are framed in dark ink as ADR files.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE · ADR-DSGN-VISUAL" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
