---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "677730c11378"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
      - docs/explanation/flow/globs-module-owns-config-and-types.md
---

# Catzc.Base.Globs owns config, types and roles: the diagram described

```text
A 1572 x 560 diagram, read left to right through two bands.
Glyphs: 1 file (olive), 5 code units (slate), 1 runner (slate), 1 external tool (grey); 7 flow edges; 6 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/globs-module-owns-config-and-types.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, a wide GLOBS MODULE band and a narrower EDGE band. It holds eight glyphs, one file, five code units, one runner and one
external tool, joined by seven straight horizontal edges, with six markers and a legend panel along the bottom. The eye lands first on the
tall code unit near the left, which spans all three rows.

## Reading path

1. Marker 1, GLOBS MODULE band, left: the file globs.yml, at mid-height.
2. Along its edge to marker 2: the tall code unit GlobsConfig → GlobSet.
3. Along three parallel edges to markers 3, 4 and 5, top to bottom: the code units Trigger projection, Change report and Protection
   identity.
4. Into the EDGE band: the runner Pipelines · workflows (top row), reached by an edge from Trigger projection, and the external tool git
   (middle row), whose edge points left into Change report.
5. Marker 6, EDGE band, bottom row: the code unit Test-Automation, reached by an edge from Protection identity.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                 |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | globs.yml (GLOBS MODULE band, left, middle row)                                                                                                       |
| code unit             | 5     | GlobsConfig → GlobSet (tall, all rows); Trigger projection, Change report, Protection identity (one per row); Test-Automation (EDGE band, bottom row) |
| runner                | 1     | Pipelines · workflows (EDGE band, top row)                                                                                                            |
| external tool         | 1     | git (EDGE band, middle row)                                                                                                                           |

The file is olive; the code units and the runner are slate, told apart by shape (the runner is a pill), all with white names. The external
tool is a grey square box.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                            |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | globs.yml → GlobsConfig → GlobSet; GlobsConfig → GlobSet → each of the three role code units; Trigger projection → Pipelines · workflows; git → Change report; Protection identity → Test-Automation |

Every edge is straight and horizontal, and none crosses another. Only the middle edge in the EDGE band runs right to left.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                        |
| ----------------- | ----------------------------- |
| olive folded page | file                          |
| slate rounded box | code unit                     |
| slate pill        | runner                        |
| grey square box   | external tool                 |
| thin arrow        | flow: output read by the next |
| grey band         | band: module boundary         |
| dark disc `1`     | marker: a Walkthrough step    |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md),
[tree](adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md) and
[value-chain map](adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md). A file or ADR lights a minimap when it
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
- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
