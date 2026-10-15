---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.md
    kind: asset-description
    body_sha: "80ce7c56c911"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md
      - docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.png
      - docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md
      - docs/.assets/explanation/adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md
      - docs/explanation/flow/no-gate-checks-rules-one-and-four.md
---

# No gate checks the runner rules 1 or 4: the diagram described

```text
A 1572 x 600 diagram: a row of four glyphs above a row of three gates, each gate's edge rising to the glyph above it.
Glyphs: 1 file (olive), 1 code unit (slate), 2 ADR-only, 3 gates; 3 flow edges; 5 rule chips (2 dashed); 7 markers.
Sidebar: world-map grid (5 lit cells), tree (10 lit groups), value-chain map (5 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/no-gate-checks-rules-one-and-four.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, RULES above
and GATES below. The RULES band holds four glyphs left to right, with no edges between them: one file, one code unit and two ADR-only glyphs
(a dashed page and a dashed rounded box). The GATES band holds three gates, each sending one edge straight up into the band above. Three
edges, five rule chips (two of them dashed), seven markers and a legend panel along the bottom. The eye lands first on the three wide grey
rhombi.

## Reading path

1. Marker 1, RULES band: the ADR-only page pipeline YAML (dashed outline, white), dashed rule chip R1.
2. Right to marker 2, the file step template, rule chip R3.
3. Right to marker 3, the code unit runner, rule chip R2.
4. Right to marker 4, the ADR-only box same RunCommand (dashed outline, white), dashed rule chip R4.
5. Down to the GATES band, left to right: marker 5, the gate Test-Pipelines with rule chip N4; marker 6, the gate expected-failures 1b;
   marker 7, the gate expected-failures · Pester.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| file                  | 1     | step template (RULES band, second)                                                                           |
| code unit             | 1     | runner (RULES band, third)                                                                                   |
| ADR-only              | 2     | pipeline YAML (a file's page shape), same RunCommand (a code unit's rounded box); RULES band, first and last |
| gate                  | 3     | Test-Pipelines, expected-failures 1b, expected-failures · Pester (GATES band)                                |

The file is an olive page and the code unit a slate box, both with white names; the ADR-only glyphs are white with dashed rims.

## Edges

| Edge kind | Count | From → to                                                                                                 |
| --------- | ----- | --------------------------------------------------------------------------------------------------------- |
| flow      | 3     | Test-Pipelines → pipeline YAML, expected-failures 1b → step template, expected-failures · Pester → runner |

All three edges are vertical, from each rhombus's top vertex up to the bottom of the glyph above it. None crosses another. same RunCommand
has no gate below it, and no edge runs along the RULES band.

## Legend

A full-width panel at the bottom of the drawing area, in four columns and three rows, left to right:

| Swatch                  | Phrase                                               |
| ----------------------- | ---------------------------------------------------- |
| olive page              | file                                                 |
| slate rounded box       | code unit                                            |
| grey rhombus, thick rim | gate                                                 |
| white dashed box        | ADR-only                                             |
| thin arrow              | flow: checks                                         |
| white chip `R1`         | rule chip: R = ADR-FLOW-CD-RUNNER, N = ADR-PIPE-NAME |
| dashed chip `R1`        | dashed rule chip: ADR-only (no gate)                 |
| dark disc `1`           | marker: a Walkthrough step                           |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.grid.md),
[tree](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.tree.md) and
[value-chain map](adr-flow-cd-runner--no-gate-checks-rules-one-and-four--governance.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-FLOW-CD-RUNNER, ADR-PIPE-NAME); the explanation articles, these descriptions and the drawing tooling
never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD-RUNNER);
  `automation × .ps1` (3 files: 3 cite ADR-PIPE-NAME); `automation × .yml` (4 files: 4 cite ADR-FLOW-CD-RUNNER, ADR-PIPE-NAME); `docs × .md`
  (6 files: 4 cite ADR-FLOW-CD-RUNNER, ADR-PIPE-NAME; 2 are the ADR file of ADR-FLOW-CD-RUNNER, ADR-PIPE-NAME); `pipelines × .yaml` (2
  files: 2 cite ADR-FLOW-CD-RUNNER, ADR-PIPE-NAME).
- **Tree** (the repository's files): 10 lit groups, `Az.DevOps` (3 files); `RootConfig` (2 files); `adr/flow` (2 files); `adr/pipe` (2
  files); `pipelines` (2 files); `.claude` (1 file); `Docs` (1 file); `Languages` (1 file); `adr/*` (1 file); `docs` (1 file). The ADR files
  `docs/adr/flow/pipeline-runner-pattern.md`, `docs/adr/pipelines/pipeline-naming-and-placement.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 5 lit cells: `DSGN × LOCAL`, because ADR-FLOW-CD-RUNNER:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15);
  `PIPE × BUILD`, because ADR-PIPE-NAME: its ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and build, quality-control,
  release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `PIPE × QC`, because ADR-PIPE-NAME: its ADR domain `pipelines`
  sits on the PIPE row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern
  (ADR-DSGN-TRACK#15); `PIPE × RELEASE`, because ADR-PIPE-NAME: its ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and
  build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `PIPE × DEPLOY`, because ADR-PIPE-NAME:
  its ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's
  default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-FLOW-CD-RUNNER · ADR-PIPE-NAME" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
