# docs/.assets/explanation/adr-flow-cd-detect--the-analyzer-names-the-raw-read--operations.drawio.md

`The analyzer names the raw read: the diagram described`

```text
A 1572 x 640 diagram, read left to right along two stacked bands.
Glyphs: 1 gate (neutral), 2 code units (slate), 3 results (green), 1 failure (red); 3 flow edges, 1 failure path; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-detect--the-analyzer-names-the-raw-read--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/the-analyzer-names-the-raw-read.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along two
full-width bands stacked top to bottom, `DEVBOX` and `PIPELINE`. It holds seven glyphs: one gate, two code units, three results and one
failure, joined by three flow edges and one failure path, with five markers and a legend panel along the bottom. The eye lands first on the
red failure in the `DEVBOX` band, the only saturated red on the drawing.

## Reading path

1. Marker 1, `DEVBOX` band, left: the gate Test-ScriptAnalyzer.
2. Along the flow edge up-right to marker 2: the result out/test-script-analyzer/.
3. Along the failure path down-right to marker 3: the failure Test-ScriptAnalyzer failed.
4. Marker 4, `PIPELINE` band, top row: the code unit Test-IsRunningInPipeline; along the flow edge to the result $true.
5. Marker 5, `PIPELINE` band, bottom row: the code unit Get-OutputRoot; along the flow edge to the result staging directory.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| gate                  | 1     | Test-ScriptAnalyzer (`DEVBOX` band, left)                                                         |
| result                | 3     | out/test-script-analyzer/ (`DEVBOX`, right, top); $true and staging directory (`PIPELINE`, right) |
| failure               | 1     | Test-ScriptAnalyzer failed (`DEVBOX` band, right, bottom)                                         |
| code unit             | 2     | Test-IsRunningInPipeline, Get-OutputRoot (`PIPELINE` band, left, stacked)                         |

The gate is a neutral rhombus with a thick light rim, the code units are slate with light names, the results are green with a bright rim,
and the failure is red with a bright red rim.

## Edges

| Edge kind                 | Count | From → to                                                                                                             |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 3     | Test-ScriptAnalyzer → out/test-script-analyzer/; Test-IsRunningInPipeline → $true; Get-OutputRoot → staging directory |
| failure path              | 1     | Test-ScriptAnalyzer → Test-ScriptAnalyzer failed                                                                      |

The two edges from the gate leave its right vertex and diverge, one up and one down; the two edges in the `PIPELINE` band are horizontal.
None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| slate rounded box | code unit                  |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps sit above it, and the map key below it names the four swatches.
