# docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md

`Only ingress is checked by gates: the diagram described`

```text
A 1572 x 680 diagram, read top to bottom through three bands: LOCAL CLONE, SERVER REMOTE, OUT.
Glyphs: 3 stores (slate), 2 gates, 1 ADR-only gate, 1 failure; 2 flow, 1 failure path, 3 ADR-only edges; 4 rule chips; 7 markers.
Sidebar: axis minimap (main cell DSGN x ACCESS), tree minimap, lens badge GOV, map key.
```

This describes what the [diagram](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/ingress-gated-the-rest-by-review.md).

## At a glance

A 1572 × 680 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands labelled LOCAL CLONE, SERVER REMOTE and OUT, and steps right as it descends. It holds seven glyphs, three stores, two
gates, one ADR-only gate and one failure, joined by six edges, with four rule chips, seven markers and a legend panel along the bottom. The
eye lands first on the red failure at the top right of the LOCAL CLONE band.

## Reading path

1. Marker 1, LOCAL CLONE band, left: the store local clone.
2. Right to marker 2: the gate local guard, with the chip V6 above its right corner.
3. Right along the red edge to marker 3: the failure Skipped on main.
4. Back to the local guard and down a dashed edge to marker 4, SERVER REMOTE band: the gate branch policy, chip R4.
5. Right to marker 5: the store server main, chip R1.
6. Down a dashed edge to marker 6, OUT band: the ADR-only gate code review in a dashed frame, chip R2 · R3 · L6.
7. Right along a dashed edge to marker 7: the store consumer clones.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                    |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------- |
| store                 | 3     | local clone (LOCAL CLONE, left), server main (SERVER REMOTE, centre right), consumer clones (OUT, right) |
| gate                  | 2     | local guard (LOCAL CLONE), branch policy (SERVER REMOTE), one above the other                            |
| ADR-only              | 1     | code review: a white dashed rhombus in a dashed frame (OUT, centre right)                                |
| failure               | 1     | Skipped on main (LOCAL CLONE, centre right)                                                              |

Stores are slate with white names.

## Edges

| Edge kind    | Count | From → to                                                                             |
| ------------ | ----- | ------------------------------------------------------------------------------------- |
| flow         | 2     | local clone → local guard, branch policy → server main                                |
| failure path | 1     | local guard → Skipped on main                                                         |
| ADR-only     | 3     | local guard → branch policy, server main → code review, code review → consumer clones |

Every edge is straight; none crosses another. Four rule chips sit beside glyphs: V6, R4, R1 and R2 · R3 · L6.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                      | Phrase                                       |
| --------------------------- | -------------------------------------------- |
| slate cylinder              | store                                        |
| rhombus with a thick rim    | gate                                         |
| red rounded box             | failure                                      |
| dashed box and dashed arrow | ADR-only (no code): glyph or edge            |
| solid arrow                 | flow: a commit moves to                      |
| red arrow                   | failure path                                 |
| white chip `R4`             | rule chip: R = REMOTE, V = VARIANT, L = LIFE |
| dark disc `1`               | marker: a Walkthrough step                   |

## Sidebar

- **Axis minimap:** the main cell is DSGN × ACCESS, framed and filled in the ACCESS pink with the you-are-here dot. Five touched cells carry
  a small grey dot: DSGN × CONFIG, DSGN × DEPLOY, AUTO × LOAD, AUTO × CONFIG and PIPE × BUILD.
- **Tree minimap:** lit tiles labelled ModuleSystem, Variants, adr/repo, Az.DevOps.BuildValidation and adr/dsgn; the ADR files are framed in
  dark ink.
- **Lens badge:** GOV, with "Supports ADR-DSGN-REMOTE · ADR-DSGN-LIFE / ADR-REPO-VARIANT" beneath it, on two lines.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
