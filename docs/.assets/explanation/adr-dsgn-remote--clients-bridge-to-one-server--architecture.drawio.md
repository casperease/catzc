# docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md

`Clients bridge to one server remote: the diagram described`

```text
A 1572 x 900 diagram, read top to bottom through four bands: IN, PULL REQUEST, SERVER REMOTE, OUT.
Glyphs: 2 stores (slate), 1 gate, 1 ADR-only gate, 2 commits (locked palette); 1 flow edge, 3 ADR-only edges; 6 markers.
Sidebar: axis minimap (main cell DSGN x ACCESS), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/clients-bridge-to-one-server.md).

## At a glance

A 1572 × 900 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands labelled IN, PULL REQUEST, SERVER REMOTE and OUT. It holds six glyphs, two stores, two gates (one of them ADR-only) and two
commits, joined by four edges, with six markers and a legend panel along the bottom. The eye lands first on the vertical column at the
right, which runs from the local clone down through both gates to HEAD.

## Reading path

1. Marker 1, IN band, right: the store local clone.
2. Down a dashed edge to marker 2, PULL REQUEST band: the ADR-only gate identity model, inside a dashed frame.
3. Down a dashed edge to marker 3: the gate branch policy.
4. Down a solid edge to marker 4, SERVER REMOTE band: the grey commit HEAD.
5. Left across the band to marker 5: the light blue commit verified point.
6. Down a dashed edge to marker 6, OUT band: the store consumer clones.

## Glyphs

| Glyph (legend phrase)   | Count | Where                                                                                      |
| ----------------------- | ----- | ------------------------------------------------------------------------------------------ |
| store                   | 2     | local clone (IN band, right), consumer clones (OUT band, left)                             |
| gate                    | 1     | branch policy (PULL REQUEST band, right, lower)                                            |
| ADR-only                | 1     | identity model: a white dashed rhombus in a dashed frame (PULL REQUEST band, right, upper) |
| commit (locked palette) | 2     | HEAD (SERVER REMOTE, right, grey), verified point (SERVER REMOTE, left, light blue)        |

Stores are slate with white names. Each commit carries its name in bold to its right. The left half of the IN and PULL REQUEST bands is
empty.

## Edges

| Edge kind | Count | From → to                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------- |
| flow      | 1     | branch policy → HEAD                                                                           |
| ADR-only  | 3     | local clone → identity model, identity model → branch policy, verified point → consumer clones |

Every edge is straight and vertical; none crosses another. HEAD and the verified point are not joined.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                      | Phrase                            |
| --------------------------- | --------------------------------- |
| slate cylinder              | store                             |
| rhombus with a thick rim    | gate                              |
| light blue and grey dots    | commit (locked palette)           |
| grey band                   | band: one side of the boundary    |
| solid arrow                 | flow: a commit moves to           |
| dashed box and dashed arrow | ADR-only (no code): glyph or edge |
| dark disc `1`               | marker: a Walkthrough step        |

## Sidebar

- **Axis minimap:** the main cell is DSGN × ACCESS, framed and filled in the ACCESS pink with the you-are-here dot. One touched cell, DSGN ×
  DEPLOY, carries a small grey dot. The DSGN and ACCESS axis labels carry a pink tick.
- **Tree minimap:** one lit tile, labelled adr/dsgn, with its two ADR files framed in dark ink.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-REMOTE · ADR-DSGN-LIFE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
