---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
    kind: asset-description
    body_sha: "0ba67eea298c"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
      - docs/explanation/design/engineer-merges-pipelines-do-the-rest.md
---

# An engineer runs the tests and merges; pipelines do the rest: the diagram described

```text
A 1572 x 600 diagram, read left to right along a top row, with failures in a band below.
Glyphs: 3 runners (slate), 1 gate, 1 ADR-only runner, 3 failures; 3 flow, 2 ADR-only, 3 failure-path edges; 8 markers.
Sidebar: world-map grid (5 lit cells), tree (8 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/engineer-merges-pipelines-do-the-rest.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two bands stand side by side on top, labelled
PERSON RUNS and PIPELINE RUNS, and one full-width band below, labelled ON FAILURE. Two span bars run above: CI over the gate and the first
pipeline runner, and CD over the dashed runner and the wide runner. The top row reads left to right; three red failure glyphs sit in the
bottom band, each straight below what raises it. The eye lands first on the wide slate runner at the right of the top row, then on the three
red boxes.

## Reading path

1. Marker 1, PERSON RUNS band: the runner `Test-Automation`.
2. Marker 2: the gate `merge the PR`.
3. Markers 3, 4 and 5, PIPELINE RUNS band, left to right: the runner `post-commit CI`, the dashed runner `L3 run`, and the wide runner
   `cd-shared · cd-<customer>`. A line also leaves the gate's top, runs right above the row, and drops into the wide runner.
4. Markers 6, 7 and 8, ON FAILURE band, left to right: the failures `PR blocked`, `red CI run` and `stage failed`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| runner                | 3     | `Test-Automation` (PERSON RUNS), `post-commit CI` and `cd-shared · cd-<customer>` (PIPELINE RUNS) |
| gate                  | 1     | `merge the PR`, PERSON RUNS, grey rhombus with a 3 px rim                                         |
| ADR-only              | 1     | `L3 run`, a white dashed runner, PIPELINE RUNS                                                    |
| failure               | 3     | `PR blocked`, `red CI run`, `stage failed`, ON FAILURE band                                       |

The runners are slate with white names; the gate is neutral grey.

## Edges

| Edge kind    | Count | From → to                                                                                          |
| ------------ | ----- | -------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → merge the PR → post-commit CI; merge the PR → cd-shared · cd-\<customer\>        |
| ADR-only     | 2     | post-commit CI → L3 run → cd-shared · cd-\<customer\>                                              |
| failure path | 3     | merge the PR → PR blocked; post-commit CI → red CI run; cd-shared · cd-\<customer\> → stage failed |

The flow edge from the gate to the wide runner is drawn in three straight segments: up from the gate's top, right above the row, and down
into the wide runner. The other edges are straight; the failure paths drop straight down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                         | Phrase                        |
| ------------------------------ | ----------------------------- |
| slate pill                     | runner                        |
| grey rhombus, 3 px rim         | gate                          |
| red rounded box                | failure: what the person sees |
| white dashed box, dashed arrow | ADR-only (no code)            |
| thin arrow                     | flow: runs next               |
| red arrow                      | failure path                  |
| dark disc `1`                  | marker: a Walkthrough step    |
| span bar                       | span bar: stages over bands   |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md),
[tree](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md) and
[value-chain map](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-LIFE, ADR-FLOW-CD); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (2 files: 2 cite ADR-DSGN-LIFE, ADR-FLOW-CD);
  `automation × .cs` (2 files: 2 cite ADR-FLOW-CD); `automation × .ps1` (3 files: 3 cite ADR-FLOW-CD); `automation × .yml` (3 files: 3 cite
  ADR-DSGN-LIFE, ADR-FLOW-CD); `docs × .md` (6 files: 4 cite ADR-DSGN-LIFE, ADR-FLOW-CD; 2 are the ADR file of ADR-DSGN-LIFE, ADR-FLOW-CD).
- **Tree** (the repository's files): 8 lit groups, `Docs` (3 files); `Maps` (3 files); `.claude` (2 files); `adr/*` (2 files); `adr/dsgn` (2
  files); `adr/flow` (2 files); `ModuleSystem` (1 file); `QualityGates` (1 file). The ADR files `docs/adr/design/commit-lifecycle.md`,
  `docs/adr/flow/cd-discipline-and-promotion-flow.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN
  row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  `DSGN × RELEASE`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release,
  deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14),
  and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because
  ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own
  value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
