# docs/.assets/explanation/adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.md

`A run past its limit stops with a message that names the limit: the diagram described`

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 actors (neutral), 2 code units (slate), 1 gate (neutral), 2 failures (red); 1 frame; 2 flow edges, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-auto-failfast--a-stopped-run-names-its-limit--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/a-stopped-run-names-its-limit.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `CALLER`, `CALL` and `STOP`. It holds seven glyphs on two rows: two actors, a gate and two code units in a frame, and two
failures. Two flow edges lead from the actors into the `CALL` band and two failure paths lead out of it into the `STOP` band, with seven
markers and a legend panel below the bands. The eye lands first on the two red failures at the right.

## Reading path

1. Marker 1, top of the `CALLER` band: the actor agent; right along the top row to marker 3, the gate Assert-BashTimeout, and on along the
   red edge to marker 6, the failure Bash call denied in the `STOP` band.
2. Marker 2, lower in the `CALLER` band: the actor developer; right into the frame of the `CALL` band, holding marker 4, the code unit
   Invoke-Executable, above marker 5, the code unit Invoke-WithTimeout.
3. From the frame's right side along the red edge to marker 7, the failure TimeoutException in the `STOP` band.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                            |
| --------------------- | ----- | ---------------------------------------------------------------- |
| actor                 | 2     | agent (`CALLER`, top), developer (`CALLER`, lower)               |
| code unit             | 2     | Invoke-Executable and Invoke-WithTimeout (`CALL`, in the frame)  |
| gate                  | 1     | Assert-BashTimeout (`CALL`, top)                                 |
| failure               | 2     | Bash call denied (`STOP`, top), TimeoutException (`STOP`, lower) |

Actors are neutral dark circles with a light rim, code units slate with white names, the gate a neutral dark rhombus, and the failures red
with a bright rim.

## Edges

| Edge kind    | Count | From → to                                                           |
| ------------ | ----- | ------------------------------------------------------------------- |
| flow         | 2     | agent → Assert-BashTimeout, developer → the frame                   |
| failure path | 2     | Assert-BashTimeout → Bash call denied, the frame → TimeoutException |

Every edge is straight and horizontal, and none crosses another. The flow edge from the developer ends on the frame's left side and the
failure path leaves its right side; neither touches the code units inside. No edge carries a label or a chip.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral circle    | actor                      |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: runs                 |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below it
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
