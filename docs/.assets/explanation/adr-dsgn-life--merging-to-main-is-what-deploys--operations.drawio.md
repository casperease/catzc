---
catzc:
  immutable:
    with_body_sha: "5df4d0f1f3f5"
    path: docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-merging-to-main-is-what-deploys-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md
      - docs/explanation/design/merging-to-main-is-what-deploys.md
---

# Merging to main is what deploys: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 2 commits, 3 runners (slate), 1 environment, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/merging-to-main-is-what-deploys.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING. It holds seven glyphs: two commits, three runners, one
environment and one ADR-only glyph. The top row runs from the brown commit to the grey one, then to a runner and a wide environment hexagon.
From the brown commit a vertical line drops through the TOPIC band and branches right three times: two solid branches to runners and a
dashed branch to the ADR-only pill. Two span bars sit inside the bands: CI over the first branch's runner, and CD over the AFTER LANDING
row. Six markers number the reading order.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled push topic, open PR.
2. Down the vertical line and right to marker 2, OUT-OF-BAND band: the runner ADO PR build, under the CI span bar.
3. Marker 3: the runner Release: Run workflow.
4. Down the dashed leg and right to marker 4: the dashed white pill, deploy topic.
5. Back to the top row, along the flow edge to marker 5, MAIN band: the grey commit, complete PR.
6. Right to marker 6, AFTER LANDING band, under the CD span bar: the runner ADO CD run, then the environment `<Customer>-<env>[-<slot>]`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------- |
| commit                | 2     | brown push topic, open PR (TOPIC), grey complete PR (MAIN)                       |
| runner                | 3     | ADO PR build and Release: Run workflow (OUT-OF-BAND), ADO CD run (AFTER LANDING) |
| environment           | 1     | `<Customer>-<env>[-<slot>]` (AFTER LANDING, top row), empty                      |
| ADR-only              | 1     | deploy topic (OUT-OF-BAND, bottom row), a dashed white pill                      |

Runners are slate pills with white names; the environment is neutral grey; the commits keep the locked commit palette.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                               |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | push topic, open PR → complete PR, complete PR → ADO CD run, ADO CD run → environment (top row); push topic, open PR → ADO PR build and → Release: Run workflow, both from a vertical trunk drawn as two leg cells with no arrowhead and two right legs with arrowheads |
| ADR-only  | 1     | push topic, open PR → deploy topic (a dashed down leg with no arrowhead from the trunk's lower bend point, then a dashed right leg with the arrowhead)                                                                                                                  |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                            |
| --------------------------------- | --------------------------------- |
| brown and grey discs              | commit (locked palette)           |
| slate pill                        | runner: a run you start or see    |
| grey hexagon                      | environment                       |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge |
| thin arrow                        | flow: starts a run                |
| dark disc `1`                     | marker: a Walkthrough step        |
| crossbar                          | span bar: stages over bands       |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md),
[tree](adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md) and
[value-chain map](adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-LIFE, ADR-DSGN-VISUAL); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `.claude × .md` (2 files: 2 cite ADR-DSGN-LIFE,
  ADR-DSGN-VISUAL); `automation × .yml` (3 files: 3 cite ADR-DSGN-LIFE, ADR-DSGN-VISUAL); `docs × .md` (5 files: 3 cite ADR-DSGN-LIFE,
  ADR-DSGN-VISUAL; 2 are the ADR file of ADR-DSGN-LIFE, ADR-DSGN-VISUAL).
- **Tree** (the repository's files): 5 lit groups, `adr/dsgn` (3 files); `.claude` (2 files); `Docs` (2 files); `adr/*` (2 files);
  `ModuleSystem` (1 file). The ADR files `docs/adr/design/commit-lifecycle.md`, `docs/adr/design/visual-design.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 3 lit cells: `DSGN × QC`, because ADR-DSGN-LIFE: its ADR
  domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release,
  deploy is its own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE · ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
