---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.md
    kind: asset-description
    body_sha: da9c97a6ff75
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# A merge to main runs CD to prod: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands, with a failures band below.
Glyphs: 1 actor, 2 runners (slate), 2 environments, 2 failures; 4 flow edges and 2 failure paths; 7 markers.
Sidebar: world-map grid (5 lit cells), tree (7 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/flow/a-merge-runs-cd-to-prod.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands on the upper row, labelled TRIGGER, CI STAGE, DEPLOY STAGES and TARGETS, with a FAILURES band below the last two. Two span bars sit
above: CD over CI STAGE and DEPLOY STAGES on the upper row, CI over CI STAGE on the lower row. It holds seven glyphs (one actor, two
runners, two environments and two failures), seven markers, and a legend panel along the bottom. The eye lands first on the large slate
capsule `Deploy_*` stages in the middle.

## Reading path

1. Marker 1, TRIGGER: the actor developer.
2. Marker 2, CI STAGE: the runner Build-Bicep.
3. Marker 3, beside the edge from Build-Bicep into `Deploy_*` stages.
4. Marker 4, TARGETS: the environment nsub · dev · test.
5. Marker 5, TARGETS: the environment psub · prod.
6. Marker 6, FAILURES: the failure Deploy-Bicep.
7. Marker 7, FAILURES: the failure Get-BicepDeploymentContext.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| actor                 | 1     | developer (TRIGGER)                                                         |
| runner                | 2     | Build-Bicep (CI STAGE), `Deploy_*` stages (DEPLOY STAGES, tall capsule)     |
| environment           | 2     | nsub · dev · test (TARGETS, upper), psub · prod (TARGETS, lower)            |
| failure               | 2     | Deploy-Bicep (FAILURES, left), Get-BicepDeploymentContext (FAILURES, right) |

The runners are slate with white names; the actor is a white circle; the environments are neutral grey; the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                            |
| ------------ | ----- | -------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | developer → Build-Bicep → `Deploy_*` stages; `Deploy_*` stages → each environment                                    |
| failure path | 2     | `Deploy_*` stages → Deploy-Bicep (straight down); `Deploy_*` stages → Get-BicepDeploymentContext (down, right, down) |

The flow edges are straight and horizontal. The second failure path is drawn as three straight segments. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch           | Phrase                      |
| ---------------- | --------------------------- |
| white circle     | actor                       |
| slate pill       | runner                      |
| grey hexagon     | environment                 |
| red rounded box  | failure                     |
| solid grey arrow | flow: what runs next        |
| solid red arrow  | failure path                |
| span bar         | span bar: stages over bands |
| dark disc `1`    | marker: a Walkthrough step  |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md), [tree](adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md) and
[value-chain map](adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md). A file or ADR lights a minimap when it cites, or is, the ADR
the slide supports (ADR-FLOW-CD); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD);
  `automation × .cs` (2 files: 2 cite ADR-FLOW-CD); `automation × .ps1` (3 files: 3 cite ADR-FLOW-CD); `automation × .yml` (3 files: 3 cite
  ADR-FLOW-CD); `docs × .md` (4 files: 3 cite ADR-FLOW-CD; 1 is the ADR file of ADR-FLOW-CD).
- **Tree** (the repository's files): 7 lit groups, `Docs` (3 files); `Maps` (3 files); `adr/*` (2 files); `adr/flow` (2 files); `.claude` (1
  file); `ModuleSystem` (1 file); `QualityGates` (1 file). The ADR file `docs/adr/flow/cd-discipline-and-promotion-flow.md` carries the
  white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × RELEAS`, because ADR-FLOW-CD: its ADR
  domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
