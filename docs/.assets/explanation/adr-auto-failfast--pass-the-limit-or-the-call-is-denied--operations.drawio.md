# docs/.assets/explanation/adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.drawio.md

`Pass the limit or the call is denied: the diagram described`

```text
A 1572 x 650 diagram, read top to bottom through three bands in two columns.
Glyphs: 1 gate (neutral), 1 result, 2 failures, 1 file (olive); 2 flow edges, 2 failure paths; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-failfast--pass-the-limit-or-the-call-is-denied--operations.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/automation/pass-the-limit-or-the-call-is-denied.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `HOOK`, `OUTCOME` and `AFTER`, in two columns: the left column runs the gate, the result and the failure; the
right column runs failure, file. It holds five glyphs, one gate, one result, two failures and one file, joined by two flow edges and two
failure paths, with five markers and a legend panel along the bottom. The eye lands first on the gate at the top left, with a red edge
running right from it.

## Reading path

1. Marker 1, `HOOK` band, left: the gate Assert-BashTimeout.
2. Down the flow edge to marker 2, `OUTCOME` band, left: the result the call runs.
3. Back to the gate and right along the failure path to marker 3, `HOOK` band, right: the failure denied, with the fix.
4. Down the flow edge to marker 4, `OUTCOME` band, right: the file out/time-safeguard.log.
5. Down the failure path from the result to marker 5, `AFTER` band, left: the failure exit 124: stopped.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| gate                  | 1     | Assert-BashTimeout (`HOOK` band, left)                                      |
| result                | 1     | the call runs (`OUTCOME` band, left)                                        |
| failure               | 2     | denied, with the fix (`HOOK` band, right); exit 124: stopped (`AFTER` band) |
| file                  | 1     | out/time-safeguard.log (`OUTCOME` band, right)                              |

The gate is a neutral rhombus with a thick rim, dark with a light rim; the result is green, the two failures red, the only red on the page,
and the file olive.

## Edges

| Edge kind    | Count | From → to                                                                         |
| ------------ | ----- | --------------------------------------------------------------------------------- |
| flow         | 2     | Assert-BashTimeout → the call runs, denied, with the fix → out/time-safeguard.log |
| failure path | 2     | Assert-BashTimeout → denied, with the fix, the call runs → exit 124: stopped      |

Every edge is straight, three vertical and one horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral rhombus   | gate                       |
| green rounded box | result                     |
| red rounded box   | failure                    |
| olive page        | file                       |
| light arrow       | flow: the call goes on     |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below it
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
