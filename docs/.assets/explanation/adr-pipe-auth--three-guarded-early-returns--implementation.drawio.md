# docs/.assets/explanation/adr-pipe-auth--three-guarded-early-returns--implementation.drawio.md

`Four checks, three returns, no fall-through: the diagram described`

```text
A 1572 x 690 diagram, read top to bottom inside one band, CODE ORDER.
Glyphs: 4 gates, 3 results, 3 failures; 6 flow edges, 3 failure paths; 7 markers.
Sidebar: axis minimap (main cell PIPE x ACCESS), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-pipe-auth--three-guarded-early-returns--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/three-guarded-early-returns.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The title reads "four checks, three returns, no
fall-through". The drawing reads top to bottom inside one full-width band, CODE ORDER, with three column headings: RETURNS, CHECK and
THROWS. It holds ten glyphs (four gates, three results, three failures) joined by nine edges, with seven markers and a legend panel along
the bottom. The eye lands first on the column of four gates in the middle.

## Reading path

1. Marker 1, centre column, first row: the gate Test-IsRunningInPipeline, with a flow edge left to its result and a failure path right to
   marker 2, the failure does not match ado.yml.
2. Down to marker 3, the gate $env:AZURE_DEVOPS_PAT, with a flow edge left to its result and nothing on its right.
3. Down to marker 4, the gate Assert-AzCliConnected, with a failure path right to marker 5, the failure Not logged in, wrong context, and
   nothing on its left.
4. Down to marker 6, the gate Assert-NotNullOrWhitespace, with a flow edge left to its result and a failure path right to marker 7, the
   failure No ADO token available.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                              |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------ |
| gate                  | 4     | Test-IsRunningInPipeline, $env:AZURE_DEVOPS_PAT, Assert-AzCliConnected, Assert-NotNullOrWhitespace (centre column) |
| result                | 3     | Bearer SYSTEM_ACCESSTOKEN (row 1), Basic $base64 (row 2), Bearer $result.Output (row 4), left column               |
| failure               | 3     | does not match ado.yml (row 1), Not logged in, wrong context (row 3), No ADO token available (row 4), right column |

Gates are grey with a thick rim, results are green and failures are red.

## Edges

| Edge kind    | Count | From → to                                                                                           |
| ------------ | ----- | --------------------------------------------------------------------------------------------------- |
| flow         | 6     | gate → gate three times, down the centre column; gates in rows 1, 2 and 4 → the result on their row |
| failure path | 3     | gates in rows 1, 3 and 4 → the failure on their row                                                 |

Every edge is straight, horizontal or vertical, and none crosses another. Every failure has a failure path into it.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| grey rhombus, thick rim | gate                       |
| green rounded box       | result                     |
| red rounded box         | failure                    |
| grey arrow              | flow: what comes next      |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is PIPE × ACCESS, framed and filled in the ACCESS pink with the you-are-here dot. Four touched cells carry
  a small grey dot: PIPE × LOAD, PIPE × DEPLOY, AUTO × ACCESS and CLOUD × ACCESS.
- **Tree minimap:** five lit tiles, labelled Az.Cli, Repository, Az.DevOps, adr/pipe and pipelines. The adr/pipe file is framed in dark ink
  as an ADR file.
- **Lens badge:** IMPL, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
