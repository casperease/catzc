---
catzc:
  immutable:
    with_body_sha: e64ca424664c
    path: docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-runner-the-step-is-named-after-its-command-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md
      - docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.png
      - docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md
      - docs/.assets/explanation/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md
      - docs/explanation/flow/the-step-is-named-after-its-command.md
---

# The step is named after its command: the diagram described

```text
A 1572 x 620 diagram, read left to right along one row, with drops below it.
Glyphs: 1 runner (slate), 3 results, 2 failures, 1 actor; 3 flow edges, 2 failure paths, 1 ADR-only edge; 7 markers.
Sidebar: world-map grid (4 lit cells), tree (5 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/the-step-is-named-after-its-command.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
RUN above and DEVELOPER below. It holds seven glyphs (one runner, three results, two failures and one actor) joined by six edges, with seven
markers and a legend panel along the bottom. The eye lands first on the row of green boxes across the PIPELINE RUN band, with two red boxes
beneath it.

## Reading path

1. Marker 1, PIPELINE RUN band: the runner pipeline step, at the left edge.
2. Down the failure path to marker 3, the failure guard throw.
3. Right from the runner to marker 2, the result step label.
4. Right to marker 4, the result Invoke-Automation [Mode], then marker 5, the result echoed command.
5. Down the failure path to marker 6, the failure Write-Exception.
6. From step label, down the dashed edge to marker 7, DEVELOPER band: the actor developer.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------- |
| runner                | 1     | pipeline step (PIPELINE RUN band, top left)                                       |
| result                | 3     | step label, Invoke-Automation [Mode], echoed command (PIPELINE RUN band, top row) |
| failure               | 2     | guard throw (under pipeline step), Write-Exception (under echoed command)         |
| actor                 | 1     | developer (DEVELOPER band, under step label)                                      |

The runner is a slate pill with a white name; results are green and failures red.

## Edges

| Edge kind    | Count | From → to                                                              |
| ------------ | ----- | ---------------------------------------------------------------------- |
| flow         | 3     | pipeline step → step label → Invoke-Automation [Mode] → echoed command |
| failure path | 2     | pipeline step → guard throw, echoed command → Write-Exception          |
| ADR-only     | 1     | step label → developer                                                 |

The flow edges are horizontal along the top row; the two failure paths and the dashed edge are vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate pill        | runner                     |
| green rounded box | result                     |
| red rounded box   | failure                    |
| white circle      | actor                      |
| thin grey arrow   | flow: run order            |
| thin red arrow    | failure path               |
| dashed arrow      | ADR-only (no code)         |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md),
[tree](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md) and
[value-chain map](adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-RUNNER); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD-RUNNER);
  `automation × .yml` (1 file: 1 cites ADR-FLOW-CD-RUNNER); `docs × .md` (3 files: 2 cite ADR-FLOW-CD-RUNNER; 1 is the ADR file of
  ADR-FLOW-CD-RUNNER); `pipelines × .yaml` (1 file: 1 cites ADR-FLOW-CD-RUNNER).
- **Tree** (the repository's files): 5 lit groups, `adr/flow` (2 files); `.claude` (1 file); `Docs` (1 file); `adr/*` (1 file); `pipelines`
  (1 file). The ADR file `docs/adr/flow/pipeline-runner-pattern.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-RUNNER:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
