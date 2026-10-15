---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.md
    kind: asset-description
    body_sha: f8a116b285b5
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Three tasks, one guard, one runner: the diagram described

```text
A 1572 x 600 diagram, read left to right through two bands side by side.
Glyphs: 2 files (olive), 1 gate, 1 failure, 4 code units (slate); 7 flow edges, 1 failure path; 8 markers.
Sidebar: world-map grid (4 lit cells), tree (5 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/three-tasks-one-guard-one-runner.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, TEMPLATE and RUNNER. It holds eight glyphs (two files, one gate, one failure and four code units) joined by eight edges, with
eight markers and a legend panel below the bands. The eye lands first on the grey rhombus between the two olive pages and the row of slate
boxes, with the red box beneath it.

## Reading path

1. Marker 1, TEMPLATE band: the file ci-automation.yaml, at the left edge.
2. Right to marker 2, the file invoke-automation.yaml.
3. Right along the edge with the fraction chip 3/3 to marker 3, the gate inline guard.
4. Down the failure path to marker 4, the failure throw.
5. Right from the gate into the RUNNER band: markers 5 to 8, the code units importer.ps1, trap, sanitize and Invoke-Command.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                      |
| --------------------- | ----- | ---------------------------------------------------------- |
| file                  | 2     | ci-automation.yaml, invoke-automation.yaml (TEMPLATE band) |
| gate                  | 1     | inline guard (TEMPLATE band, right)                        |
| failure               | 1     | throw (TEMPLATE band, under the gate)                      |
| code unit             | 4     | importer.ps1, trap, sanitize, Invoke-Command (RUNNER band) |

Files are olive pages and code units slate boxes, both with white names; the gate is a grey rhombus with a 3 px rim.

## Edges

| Edge kind    | Count | From → to                                                                                                    |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------ |
| flow         | 7     | ci-automation.yaml → invoke-automation.yaml → inline guard → importer.ps1 → trap → sanitize → Invoke-Command |
| failure path | 1     | inline guard → throw                                                                                         |

The flow edges are horizontal along one row; the failure path drops straight down from the gate's bottom vertex. None crosses another. One
fraction chip, 3/3, sits just above the edge into the gate.

## Legend

A full-width panel below the bands, in four columns, left to right:

| Swatch                  | Phrase                                    |
| ----------------------- | ----------------------------------------- |
| olive page              | file                                      |
| grey rhombus, thick rim | gate                                      |
| slate rounded box       | code unit                                 |
| red rounded box         | failure                                   |
| thin grey arrow         | flow: next in code order                  |
| thin red arrow          | failure path                              |
| bold `3/3`              | fraction chip: tasks that carry the guard |
| dark disc `1`           | marker: a Walkthrough step                |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md),
[tree](adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md) and
[value-chain map](adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-RUNNER); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD-RUNNER);
  `automation × .yml` (1 file: 1 cites ADR-FLOW-CD-RUNNER); `docs × .md` (3 files: 2 cite ADR-FLOW-CD-RUNNER; 1 is the ADR file of
  ADR-FLOW-CD-RUNNER); `pipelines × .yaml` (1 file: 1 cites ADR-FLOW-CD-RUNNER).
- **Tree** (the repository's files): 5 lit groups, `adr/flow` (2 files); `.claude` (1 file); `Docs` (1 file); `adr/*` (1 file); `pipelines`
  (1 file). The ADR file `docs/adr/flow/pipeline-runner-pattern.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-RUNNER:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
