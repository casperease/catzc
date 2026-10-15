---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.md
    kind: asset-description
    body_sha: "7df1b9b44c0f"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# The runner is the only seam into PowerShell: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands, with a fourth band below.
Glyphs: 2 files (olive), 1 runner, 2 code units (slate), 1 actor; 5 flow edges; 6 markers.
Sidebar: world-map grid (4 lit cells), tree (5 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/the-runner-is-the-only-seam.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands in one row, labelled YAML, ADO TASK and POWERSHELL, with a fourth band, DEVELOPER, below POWERSHELL. It holds six glyphs (two files,
one runner, two code units and one actor) joined by five edges, with six markers and a legend panel along the bottom. The eye lands first on
the slate pill alone in the middle band.

## Reading path

1. Marker 1, YAML band: the file pipeline YAML, at the left edge.
2. Right along the edge with the fraction chip 6/7 to marker 2, the file invoke-automation.yaml.
3. Right into the ADO TASK band: marker 3, the runner task by Mode.
4. Right into the POWERSHELL band: marker 4, the code unit Invoke-AdoScript.ps1, then marker 5, the code unit importer.ps1.
5. Down to marker 6, DEVELOPER band: the actor developer, whose edge rises to importer.ps1.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                |
| --------------------- | ----- | ---------------------------------------------------- |
| file                  | 2     | pipeline YAML, invoke-automation.yaml (YAML band)    |
| runner                | 1     | task by Mode (ADO TASK band)                         |
| code unit             | 2     | Invoke-AdoScript.ps1, importer.ps1 (POWERSHELL band) |
| actor                 | 1     | developer (DEVELOPER band, under importer.ps1)       |

Files are olive pages; the runner and the code units are slate, told apart by the pill and the rounded box; all carry white names.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                         |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | pipeline YAML → invoke-automation.yaml, invoke-automation.yaml → task by Mode, task by Mode → Invoke-AdoScript.ps1, Invoke-AdoScript.ps1 → importer.ps1, developer → importer.ps1 |

Four edges are straight and horizontal along one row; the fifth is vertical, from the actor up to importer.ps1. None crosses another. One
fraction chip, 6/7, sits just above the first edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                      |
| ----------------- | ------------------------------------------- |
| olive page        | file                                        |
| slate pill        | runner                                      |
| slate rounded box | code unit                                   |
| white circle      | actor                                       |
| thin arrow        | flow: calls                                 |
| bold `6/7`        | fraction chip: root pipelines that reach it |
| dark disc `1`     | marker: a Walkthrough step                  |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.grid.md),
[tree](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.tree.md) and
[value-chain map](adr-flow-cd-runner--the-runner-is-the-only-seam--architecture.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-FLOW-CD-RUNNER); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD-RUNNER);
  `automation × .yml` (1 file: 1 cites ADR-FLOW-CD-RUNNER); `docs × .md` (3 files: 2 cite ADR-FLOW-CD-RUNNER; 1 is the ADR file of
  ADR-FLOW-CD-RUNNER); `pipelines × .yaml` (1 file: 1 cites ADR-FLOW-CD-RUNNER).
- **Tree** (the repository's files): 5 lit groups, `adr/flow` (2 files); `.claude` (1 file); `Docs` (1 file); `adr/*` (1 file); `pipelines`
  (1 file). The ADR file `docs/adr/flow/pipeline-runner-pattern.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-RUNNER:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
