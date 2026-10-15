---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
    kind: asset-description
    body_sha: "86d2f799afe9"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
      - docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md
---

# Declare or add a folder, and the gate names overlaps: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands, the gate at top right.
Glyphs: 3 files (olive), 1 code unit (slate), 1 gate (grey), 2 failures (red).
Edges: 2 flow, 2 failure paths; 7 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three files, one code unit, one gate and two failures, joined
by two flow edges and two failure paths, with seven markers and a legend panel. The eye lands first on the gate, a large grey rhombus at the
right of the top band.

## Reading path

1. Marker 1, top band, left: the file globs.yml: deployable-unit, with a long edge right to the gate.
2. Marker 2, middle band, left: the file globs.yml: loose-fileset, with no edge.
3. Markers 3 and 4, bottom band, left: the file globs.yml: layer: module and, along a short failure path, the failure Rejected at config
   load.
4. Marker 5, bottom band, right: the wide code unit Add a module folder, with a vertical edge up through the middle band to the gate.
5. Marker 6, on the top vertex of the gate Test-GlobSetIndependence, top band.
6. Marker 7, top band, far right: the failure Issue per pair, at the end of the gate's failure path.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                  |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------ |
| file                  | 3     | globs.yml: deployable-unit (top), globs.yml: loose-fileset (middle), globs.yml: layer: module (bottom) |
| code unit             | 1     | Add a module folder (bottom band, right)                                                               |
| gate                  | 1     | Test-GlobSetIndependence (top band, right)                                                             |
| failure               | 2     | Rejected at config load (bottom band), Issue per pair (top band, far right)                            |

Files are olive and the code unit slate, both with white names; the gate is a grey rhombus with a 3 px rim; the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                 |
| ------------ | ----- | ------------------------------------------------------------------------- |
| flow         | 2     | globs.yml: deployable-unit → gate, Add a module folder → gate             |
| failure path | 2     | gate → Issue per pair, globs.yml: layer: module → Rejected at config load |

Every edge is straight and none crosses another. The file in the middle band has no edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| grey rhombus      | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: checked by the gate  |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md),
[tree](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md) and
[value-chain map](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
