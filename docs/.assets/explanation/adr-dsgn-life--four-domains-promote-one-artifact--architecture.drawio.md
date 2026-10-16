---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "1bdb0ec3d12e"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md
      - docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md
      - docs/.assets/explanation/adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md
      - docs/explanation/design/four-domains-promote-one-artifact.md
---

# Four pipeline kinds promote one artifact: the diagram described

```text
A 1572 x 600 diagram, read left to right through five bands standing side by side.
Glyphs: 8 commits, 1 runner (slate), 5 environments (grey), 1 store (slate); 9 flow edges; 7 markers.
Sidebar: world-map grid (5 lit cells), tree (8 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--four-domains-promote-one-artifact--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/four-domains-promote-one-artifact.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through five tall
bands standing side by side as columns, labelled GIT, CI, CD, DEPLOY-NON-PROD and DEPLOY-PROD. Three span bars run above them: CI over the
CI band, CD over the CD band, and DEPLOY over the last two bands. One row of glyphs crosses the bands at mid-height: three commits, one
runner and five environments, each environment holding one commit near its top. A wide store lies below the row, from the CI band to the
right edge. The eye lands first on the row of five grey hexagons, each with a coloured commit inside.

## Reading path

1. Marker 1, GIT band: the brown commit `topic`, then the grey commit `main` to its right.
2. Marker 2, CI band: the runner `CI engine`, then the yellow commit `BVT`.
3. Marker 3, CD band: the environment `on-demand env`, holding a blue commit.
4. Markers 4 and 5, DEPLOY-NON-PROD band: the environments `main-uat` (light-blue commit) and `release-uat` (light-green commit).
5. Marker 6, DEPLOY-PROD band: the environments `pre-prod` and `production`, each holding a green commit.
6. Down from the runner to marker 7: the store `tagged artifact`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                           |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------- |
| commit                | 8     | brown and grey in the GIT band, yellow in the CI band, one inside each of the five environments |
| runner                | 1     | `CI engine`, CI band                                                                            |
| environment           | 5     | `on-demand env` (CD band), `main-uat`, `release-uat`, `pre-prod`, `production`                  |
| store                 | 1     | `tagged artifact`, below the row, CI band to DEPLOY-PROD band                                   |

The runner and the store are slate with white names; the environments are neutral grey, each coloured only by the commit it holds.

## Edges

| Edge kind | Count | From → to                                                                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------- |
| flow      | 9     | topic → main → CI engine → BVT → on-demand env → main-uat → release-uat → pre-prod → production; CI engine → tagged artifact |

Eight edges run straight and horizontal along the row; one drops straight down from the runner into the store. None crosses another. No
chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                              | Phrase                            |
| ----------------------------------- | --------------------------------- |
| seven small commits, brown to green | commit (locked palette)           |
| slate pill                          | runner                            |
| grey hexagon                        | environment, holding its occupant |
| slate cylinder                      | store                             |
| thin arrow                          | flow: promotes, or builds         |
| span bar                            | span bar: stages over bands       |
| dark disc `1`                       | marker: a Walkthrough step        |
| grey band                           | `band: one pipeline domain`       |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--four-domains-promote-one-artifact--architecture.grid.md),
[tree](adr-dsgn-life--four-domains-promote-one-artifact--architecture.tree.md) and
[value-chain map](adr-dsgn-life--four-domains-promote-one-artifact--architecture.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-LIFE, ADR-FLOW-CD); the explanation articles, these descriptions and the drawing tooling never
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
- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
