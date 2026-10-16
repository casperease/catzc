---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "5657707d9345"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
      - docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.png
      - docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
      - docs/.assets/explanation/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md
      - docs/explanation/flow/a-step-only-names-a-command.md
---

# A pipeline step only names a command: the diagram described

```text
A 1572 x 600 diagram, read left to right along one row, then up from a lower band.
Glyphs: 2 runners, 2 code units (slate), 1 actor; 3 flow edges, 1 ADR-only edge; 5 markers.
Sidebar: world-map grid (4 lit cells), tree (5 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/flow/a-step-only-names-a-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
above and DEVELOPER below. It holds five glyphs (two runners, two code units and one actor) joined by four edges, with five markers and a
legend panel along the bottom. The eye lands first on the two slate pills at the left of the PIPELINE band.

## Reading path

1. Marker 1, PIPELINE band: the runner pipeline step, at the left edge.
2. Right to marker 2, the runner pipeline task.
3. Right to marker 3, the code unit runner.
4. A long edge right to marker 4, the code unit same command, at the right edge.
5. Marker 5, DEVELOPER band: the actor developer, whose dashed edge rises to same command.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                     |
| --------------------- | ----- | --------------------------------------------------------- |
| runner                | 2     | pipeline step, pipeline task (PIPELINE band, left)        |
| code unit             | 2     | runner (PIPELINE band, centre left), same command (right) |
| actor                 | 1     | developer (DEVELOPER band, under same command)            |

Runners and code units are slate with white names; the pill shape tells a runner from a code unit's rounded box.

## Edges

| Edge kind | Count | From → to                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------- |
| flow      | 3     | pipeline step → pipeline task, pipeline task → runner, runner → same command |
| ADR-only  | 1     | developer → same command                                                     |

The flow edges are horizontal along one row; the ADR-only edge is vertical and dashed. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| slate rounded box | code unit                   |
| white circle      | actor                       |
| thin arrow        | flow: passes the command on |
| dashed arrow      | ADR-only (no code)          |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md),
[tree](adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md) and
[value-chain map](adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md). A file or ADR lights a minimap when it cites, or is, the
ADR the slide supports (ADR-FLOW-CD-RUNNER); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD-RUNNER);
  `automation × .yml` (1 file: 1 cites ADR-FLOW-CD-RUNNER); `docs × .md` (3 files: 2 cite ADR-FLOW-CD-RUNNER; 1 is the ADR file of
  ADR-FLOW-CD-RUNNER); `pipelines × .yaml` (1 file: 1 cites ADR-FLOW-CD-RUNNER).
- **Tree** (the repository's files): 5 lit groups, `adr/flow` (2 files); `.claude` (1 file); `Docs` (1 file); `adr/*` (1 file); `pipelines`
  (1 file). The ADR file `docs/adr/flow/pipeline-runner-pattern.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-RUNNER:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
