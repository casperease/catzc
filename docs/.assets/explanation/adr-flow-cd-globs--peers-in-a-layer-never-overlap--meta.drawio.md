---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.md
    kind: asset-description
    body_sha: "0502bfeeb85a"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Peers never overlap, except loose-filesets: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 1 gate (grey); 2 flow edges; 4 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/peers-in-a-layer-never-overlap.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three named sets and one gate, joined by two flow edges, with
four markers and a legend panel along the bottom. The eye lands first on the gate at the right of the top band.

## Reading path

1. Marker 1, top band: the named set What ships.
2. Marker 2, middle band: the named set Cross-cutting surfaces, with no edge.
3. Marker 3, bottom band: the wide named set Module space.
4. Marker 4, on the top vertex of the gate Peers disjoint, top band, and its two edges: left to What ships, down through the middle band to
   Module space.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------- |
| named set             | 3     | What ships (top band), Cross-cutting surfaces (middle band), Module space (bottom band, wide) |
| gate                  | 1     | Peers disjoint (top band, right of What ships)                                                |

Named sets are mauve with white names; the gate is a grey rhombus with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                  |
| --------- | ----- | ---------------------------------------------------------- |
| flow      | 2     | Peers disjoint → What ships, Peers disjoint → Module space |

Both edges are straight: one horizontal, one vertical. Neither touches Cross-cutting surfaces.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| grey rhombus      | gate                       |
| thin arrow        | flow: checks its peers     |
| grey band         | band: one layer            |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.grid.md),
[tree](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.tree.md) and
[value-chain map](adr-flow-cd-globs--peers-in-a-layer-never-overlap--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × AUTOMA`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
