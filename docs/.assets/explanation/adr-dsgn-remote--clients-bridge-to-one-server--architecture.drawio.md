# docs/.assets/explanation/adr-dsgn-remote--clients-bridge-to-one-server--architecture.drawio.md

`Clients bridge to one server remote: the diagram described`

```text
A 1572 x 900 diagram, read top to bottom through four bands: IN, PULL REQUEST, SERVER REMOTE, OUT.
Glyphs: 2 stores (slate), 1 gate, 1 ADR-only gate, 2 commits (locked palette); 1 flow edge, 3 ADR-only edges; 6 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (4 lit cells), map key.
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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-remote--clients-bridge-to-one-server--architecture.grid.md),
[tree](adr-dsgn-remote--clients-bridge-to-one-server--architecture.tree.md) and
[value-chain map](adr-dsgn-remote--clients-bridge-to-one-server--architecture.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-LIFE, ADR-DSGN-REMOTE); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `.claude × .md` (1 file: 1 cites ADR-DSGN-LIFE);
  `automation × .yml` (2 files: 3 cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE); `docs × .md` (5 files: 5 cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE; 2 are
  the ADR file of ADR-DSGN-LIFE, ADR-DSGN-REMOTE).
- **Tree** (the repository's files): 5 lit groups, `adr/dsgn` (3 files); `adr/*` (2 files); `.claude` (1 file); `Docs` (1 file);
  `ModuleSystem` (1 file). The ADR files `docs/adr/design/commit-lifecycle.md`, `docs/adr/design/server-remote-integration.md` carry the
  white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-DSGN-REMOTE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-REMOTE: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × RELEAS`, because
  ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own
  value-chain concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-DSGN-REMOTE · ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
