---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.md
    kind: asset-description
    body_sha: "96353e592a57"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md
      - docs/explanation/design/one-door-in-one-stable-point-out.md
---

# One door in, one stable point out: the diagram described

```text
A 1572 x 650 diagram, read top to bottom through three bands: IN, SERVER REMOTE, OUT.
Glyphs: 2 stores (slate), 1 gate, 2 commits (locked palette); 1 flow edge, 2 ADR-only edges; 5 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/one-door-in-one-stable-point-out.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands labelled IN, SERVER REMOTE and OUT. It holds five glyphs, two stores, one gate and two commits, joined by three edges, with
five markers and a legend panel along the bottom. The eye lands first on the gate at the right of the IN band, with the only solid edge
running down from it.

## Reading path

1. Marker 1, IN band, left of centre: the store local clone.
2. Right along a dashed edge to marker 2: the gate pull request.
3. Down a solid edge into the SERVER REMOTE band, to marker 3: the grey commit HEAD.
4. Left across the band to marker 4: the light blue commit verified point, under the local clone.
5. Down a dashed edge to marker 5, OUT band: the store consumer clones.

## Glyphs

| Glyph (legend phrase)   | Count | Where                                                                               |
| ----------------------- | ----- | ----------------------------------------------------------------------------------- |
| store                   | 2     | local clone (IN band, left), consumer clones (OUT band, left)                       |
| gate                    | 1     | pull request (IN band, right)                                                       |
| commit (locked palette) | 2     | verified point (SERVER REMOTE, left, light blue), HEAD (SERVER REMOTE, right, grey) |

Stores are slate with white names. Each commit carries its name in bold to its right.

## Edges

| Edge kind | Count | From → to                                                    |
| --------- | ----- | ------------------------------------------------------------ |
| flow      | 1     | pull request → HEAD                                          |
| ADR-only  | 2     | local clone → pull request, verified point → consumer clones |

Every edge is straight; none crosses another. The verified point and HEAD are not joined.

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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.grid.md),
[tree](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.tree.md) and
[value-chain map](adr-dsgn-remote--one-door-in-one-stable-point-out--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-REMOTE); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-DSGN-REMOTE);
  `docs × .md` (3 files: 2 cite ADR-DSGN-REMOTE; 1 is the ADR file of ADR-DSGN-REMOTE).
- **Tree** (the repository's files): 3 lit groups, `adr/dsgn` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/design/server-remote-integration.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × BUILD`, because ADR-DSGN-REMOTE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-REMOTE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-DSGN-REMOTE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
