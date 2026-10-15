# docs/.assets/explanation/adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.md

`The session is the deploy target: the diagram described`

```text
A 1572 x 640 diagram, read left to right through two bands.
Glyphs: 1 external tool (neutral), 1 gate (neutral), 1 result, 1 failure; 2 flow edges, 1 failure path; 4 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/the-session-is-the-deploy-target.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two
bands, `SESSION` on the left and the wider `GUARD` on the right. It holds four glyphs, one external tool, one gate, one result and one
failure, joined by two flow edges and one failure path, with four markers and a legend panel along the bottom. The eye lands first on the
gate in the middle of the guard band, with the green result to its right and the red failure below it.

## Reading path

1. Marker 1, session band: the external tool az session.
2. Right along the flow edge into the guard band, to marker 2: the gate subscription guard.
3. Right along the second flow edge to marker 3: the result deploy target.
4. Down the failure path from the gate to marker 4: the failure mis-wired connection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                         |
| --------------------- | ----- | --------------------------------------------- |
| external tool         | 1     | az session (session band)                     |
| gate                  | 1     | subscription guard (guard band, centre)       |
| result                | 1     | deploy target (guard band, right)             |
| failure               | 1     | mis-wired connection (guard band, below gate) |

The external tool and the gate are neutral, dark with a light rim; the result is green and the failure red, both with light names.

## Edges

| Edge kind                   | Count | From → to                                               |
| --------------------------- | ----- | ------------------------------------------------------- |
| flow: decides the next step | 2     | az session → subscription guard → deploy target         |
| failure path                | 1     | subscription guard → mis-wired connection               |

Every edge is straight: the two flow edges run horizontally on one line, and the failure path runs vertically down from the gate.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                      |
| ----------------------- | --------------------------- |
| neutral square box      | external tool               |
| neutral rhombus         | gate                        |
| green rounded box       | result                      |
| red rounded box         | failure                     |
| thin arrow              | flow: decides the next step |
| red arrow               | failure path                |
| light disc `1`          | marker: a Walkthrough step  |

## Sidebar

The lens badge reads `META`. The three minimaps sit above it, and the map key below it names the four swatches.
