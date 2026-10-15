---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.md
    kind: asset-description
    body_sha: "449c92e6182d"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md
      - docs/explanation/flow/two-declared-layers-one-derived.md
---

# Two layers declared, the third derived: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands under two span bars.
Glyphs: 6 named sets (mauve); 1 thick edge with a 4/4 fraction chip; 6 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/two-declared-layers-one-derived.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE, under two span bars labelled DECLARED (over the left half) and DERIVED
(over the right half). It holds six named sets, one thick edge with a fraction chip, six markers, and a legend panel along the bottom. The
eye lands first on the short thick edge between the two named sets in the top band.

## Reading path

1. The span bars above the top band: DECLARED on the left, DERIVED on the right.
2. Markers 1 and 2, top band, left half: the named sets Configured units and Base unit, joined by the thick edge.
3. Markers 3 and 4, middle band: Declared loose-filesets under DECLARED, Reserved umbrellas under DERIVED.
4. Markers 5 and 6, bottom band, right half: Module sets and module-leftovers. The left half of the bottom band is empty.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 6     | Configured units, Base unit (top band, left); Declared loose-filesets (middle, left); Reserved umbrellas (middle, right); Module sets, module-leftovers (bottom, right) |

Named sets are mauve with white names.

## Edges

| Edge kind              | Count | From → to                    |
| ---------------------- | ----- | ---------------------------- |
| thick (to a named set) | 1     | Configured units → Base unit |

The edge is short and horizontal, with a bold `4/4` fraction chip just above it.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                             |
| ----------------- | ---------------------------------- |
| mauve rounded box | named set                          |
| grey band         | band: one layer                    |
| thick arrow       | compose, to a named set            |
| bold `4/4`        | fraction chip: units with the edge |
| span bar          | span bar: declared or derived      |
| dark disc `1`     | marker: a Walkthrough step         |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.grid.md),
[tree](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.tree.md) and
[value-chain map](adr-flow-cd-globs--two-declared-layers-one-derived--architecture.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
