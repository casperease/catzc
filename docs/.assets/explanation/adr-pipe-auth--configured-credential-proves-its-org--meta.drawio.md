# docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md

`The first configured credential wins: the diagram described`

```text
A 1572 x 610 diagram, read top to bottom inside one band, PRECEDENCE.
Glyphs: 3 gates, 1 result, 1 failure; 5 flow edges, 2 failure paths; 5 markers.
Sidebar: axis minimap (main cell PIPE x ACCESS), tree minimap, lens badge META, map key.
```

This describes what the [diagram](adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/configured-credential-proves-its-org.md).

## At a glance

A 1572 × 610 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band, PRECEDENCE, with three column headings: RETURNS, FIRST CONFIGURED SOURCE and RAISES. It holds five glyphs (three gates, one
result, one failure) joined by seven edges, with five markers and a legend panel along the bottom. The eye lands first on the column of
three gates in the middle, between a tall result on the left and a tall failure on the right.

## Reading path

1. Marker 1, centre column, top: the gate Pipeline token.
2. Down a flow edge to marker 2, the gate Personal access token, and down again to marker 3, the gate Interactive login.
3. Left along the three flow edges to marker 4, the result Authorization header.
4. Right along the two failure paths, from the top and bottom gates, to marker 5, the failure Own error, no fallback.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| gate                  | 3     | Pipeline token, Personal access token, Interactive login (centre column, top to bottom) |
| result                | 1     | Authorization header (left column, spanning all three rows)                             |
| failure               | 1     | Own error, no fallback (right column, spanning all three rows)                          |

Gates are grey with a thick rim, the result is green and the failure is red.

## Edges

| Edge kind    | Count | From → to                                                                                    |
| ------------ | ----- | -------------------------------------------------------------------------------------------- |
| flow         | 5     | Pipeline token → Personal access token → Interactive login; each gate → Authorization header |
| failure path | 2     | Pipeline token → Own error, no fallback; Interactive login → Own error, no fallback          |

Every edge is straight, horizontal or vertical, and none crosses another. The middle gate has no failure path.

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

- **Axis minimap:** the main cell is PIPE × ACCESS, framed and filled in the ACCESS pink with the you-are-here dot. Two touched cells carry
  a small grey dot: PIPE × LOAD and PIPE × DEPLOY.
- **Tree minimap:** three lit tiles, labelled Az.DevOps, adr/pipe and pipelines. The adr/pipe file is framed in dark ink as an ADR file.
- **Lens badge:** META, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
