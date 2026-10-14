# docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md

`Edit globs.yml, then read the output: the diagram described`

```text
A 1572 x 560 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 1 gate, 3 code units (slate), 3 results (green); 7 flow edges; 8 markers.
Sidebar: axis minimap (main cell PIPE x GLOBS), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/edit-globs-yml-then-read-the-output.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands side by side, labelled YOU EDIT, CONFIG LOAD, YOU RUN and YOU SEE. It holds eight glyphs, one file, one gate, three code units and
three results, joined by seven straight edges, with eight markers and a legend panel along the bottom. The eye lands first on the tall
rhombus in the CONFIG LOAD band, the gate.

## Reading path

1. Marker 1, YOU EDIT band, middle row: the file globs.yml.
2. Along its edge to marker 2, at the top vertex of the gate Config load, a tall rhombus.
3. Along three edges leaving the gate's right side to markers 3, 4 and 5, YOU RUN band, top to bottom: the code units Get-GlobSetTrigger,
   Get-ChangedGlobSet and Test-Automation.
4. Along three edges to markers 6, 7 and 8, YOU SEE band: the results Projected paths, Touched globsets and Skip line.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------- |
| file                  | 1     | globs.yml (YOU EDIT band, middle row)                                  |
| gate                  | 1     | Config load (CONFIG LOAD band, all rows), 3 px rim                     |
| code unit             | 3     | Get-GlobSetTrigger, Get-ChangedGlobSet, Test-Automation (YOU RUN band) |
| result                | 3     | Projected paths, Touched globsets, Skip line (YOU SEE band)            |

The file is olive and the code units are slate, both with white names; the gate is grey and the results light green.

## Edges

| Edge kind | Count | From → to                                                                                                   |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------- |
| flow      | 7     | globs.yml → Config load; Config load → each of the three code units; each code unit → the result in its row |

Every edge is straight and horizontal; none crosses another. The top and bottom edges leave the gate from its slanted sides.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                     |
| ---------------------- | -------------------------- |
| olive folded page      | file                       |
| grey rhombus, 3 px rim | gate                       |
| slate rounded box      | code unit                  |
| green rounded box      | result                     |
| thin arrow             | flow: feeds, then prints   |
| dark disc `1`          | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is PIPE × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. Three touched cells carry
  a small grey dot: AUTO × GLOBS, AUTO × BUILD and PIPE × DEPLOY.
- **Tree minimap:** lit tiles labelled QualityGates, Globs, adr/flow and pipelines.
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
