---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-cd-builds-once-then-deploys-prod-itself-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "6b9c519269c0"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
      - docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png
      - docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
      - docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
      - docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md
---

# The customer CD pipeline builds once, then deploys prod itself: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 runners (slate), 3 results, 2 environments; 10 flow edges; 6 markers.
Sidebar: world-map grid (5 lit cells), tree (7 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled CI STAGE, DEPLOY STAGES and TARGETS. Two span bars sit above them: CD over the first two bands on the upper
row, CI over the first band on the lower row. It holds nine glyphs (four runners, three results and two environments), six markers, and a
legend panel along the bottom. The eye lands first on the tall slate capsule Build-Bicep at the far left.

## Reading path

1. Marker 1, CI STAGE: the runner Build-Bicep, a tall capsule.
2. Marker 2, CI STAGE: the first of three stacked results, foundation, then discovery and expedition below it.
3. Marker 3, DEPLOY STAGES: the runner Deploy_Foundation, the top of three stacked runners.
4. Marker 4, beside the edge from Deploy_Foundation down to Deploy_Discovery.
5. Marker 5, TARGETS: the environment nsub · dev · test.
6. Marker 6, TARGETS: the environment psub · prod.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                         |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| runner                | 4     | Build-Bicep (CI STAGE, tall), Deploy_Foundation, Deploy_Discovery, Deploy_Expedition (DEPLOY STAGES, stacked) |
| result                | 3     | foundation, discovery, expedition (CI STAGE, stacked)                                                         |
| environment           | 2     | nsub · dev · test (TARGETS, upper), psub · prod (TARGETS, lower)                                              |

The runners are slate with white names; the results are light green; the environments are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                       |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 10    | Build-Bicep → each of the three results; each result → the runner beside it; Deploy_Foundation → Deploy_Discovery → Deploy_Expedition; the DEPLOY STAGES band's right border → each environment |

Every edge is straight. Six run horizontally in three rows, two run vertically between the stacked deploy runners, and two leave the right
border of the DEPLOY STAGES band, one at the height of each environment. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| green rounded box | result                      |
| grey hexagon      | environment                 |
| solid arrow       | flow: next in code order    |
| span bar          | span bar: stages over bands |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md),
[tree](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md) and
[value-chain map](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD);
  `automation × .cs` (2 files: 2 cite ADR-FLOW-CD); `automation × .ps1` (3 files: 3 cite ADR-FLOW-CD); `automation × .yml` (3 files: 3 cite
  ADR-FLOW-CD); `docs × .md` (4 files: 3 cite ADR-FLOW-CD; 1 is the ADR file of ADR-FLOW-CD).
- **Tree** (the repository's files): 7 lit groups, `Docs` (3 files); `Maps` (3 files); `adr/*` (2 files); `adr/flow` (2 files); `.claude` (1
  file); `ModuleSystem` (1 file); `QualityGates` (1 file). The ADR file `docs/adr/flow/cd-discipline-and-promotion-flow.md` carries the
  white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because ADR-FLOW-CD: its ADR
  domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
