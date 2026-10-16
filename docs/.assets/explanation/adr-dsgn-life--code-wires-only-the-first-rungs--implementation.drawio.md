---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: f8d68fa2cf78
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md
      - docs/explanation/design/code-wires-only-the-first-rungs.md
---

# The pipelines wire only topic, landed and BVT: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands standing side by side.
Glyphs: 3 commits, 8 runners (slate), 1 ADR-only runner; 8 flow edges, 1 ADR-only edge; 8 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/code-wires-only-the-first-rungs.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands standing side by side as columns, labelled PRE-COMMIT, POST-COMMIT and DEPLOY STAGES. A narrow band labelled BVT sits inside
POST-COMMIT and holds three runners stacked top to bottom. Two span bars run above: CI over PRE-COMMIT and POST-COMMIT up to the BVT band,
and CD from the dashed runner to the right edge. The eye lands first on the three wide slate runners stacked in DEPLOY STAGES.

## Reading path

1. Marker 1, PRE-COMMIT band: the brown commit `topic`, then the runner `pr: [main]`.
2. Marker 2, POST-COMMIT band: the grey commit `landed`, then the runner `trigger: [main]`, whose arrow enters the BVT band.
3. Markers 3, 4 and 5, BVT band, top to bottom: the runners `CD stage CI`, `ci-automation` and `ci-infrastructure`.
4. Right from `CD stage CI` to the yellow commit `BVT`; marker 6 below it, on the dashed runner `L3 run`.
5. Right from the yellow commit to marker 7, DEPLOY STAGES band: the runner `Deploy_Foundation`, then down to marker 8, `Deploy_Discovery`,
   and down again to `Deploy_Expedition`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| commit                | 3     | brown `topic` (PRE-COMMIT), grey `landed` and yellow `BVT` (POST-COMMIT); each name sits above its commit |
| runner                | 8     | `pr: [main]`, `trigger: [main]`, three in the BVT band, three in DEPLOY STAGES                            |
| ADR-only              | 1     | `L3 run`, a white dashed runner below the yellow commit                                                   |

The runners are slate with white names, so none shares the yellow of the BVT commit beside them.

## Edges

| Edge kind | Count | From → to                                                                                                                                        |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 8     | topic → pr: [main] → landed → trigger: [main] → BVT band; CD stage CI → yellow commit → Deploy_Foundation → Deploy_Discovery → Deploy_Expedition |
| ADR-only  | 1     | yellow commit → L3 run                                                                                                                           |

The row edges are straight and horizontal; the deploy edges and the ADR-only edge run straight down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                         | Phrase                       |
| ------------------------------ | ---------------------------- |
| three small commits            | commit (locked palette)      |
| slate pill                     | runner                       |
| white dashed box, dashed arrow | ADR-only (no code)           |
| thin arrow                     | flow: runs next              |
| span bar                       | span bar: stages over bands  |
| grey band                      | band: trigger or stage group |
| dark disc `1`                  | marker: a Walkthrough step   |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.grid.md),
[tree](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.tree.md) and
[value-chain map](adr-dsgn-life--code-wires-only-the-first-rungs--implementation.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-LIFE); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `.claude × .md` (1 file: 1 cites ADR-DSGN-LIFE);
  `automation × .yml` (2 files: 2 cite ADR-DSGN-LIFE); `docs × .md` (4 files: 3 cite ADR-DSGN-LIFE; 1 is the ADR file of ADR-DSGN-LIFE).
- **Tree** (the repository's files): 5 lit groups, `adr/*` (2 files); `adr/dsgn` (2 files); `.claude` (1 file); `Docs` (1 file);
  `ModuleSystem` (1 file). The ADR file `docs/adr/design/commit-lifecycle.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 3 lit cells: `DSGN × QC`, because ADR-DSGN-LIFE: its ADR
  domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR
  domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
