---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "2b0e5e2da4c1"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md
      - docs/explanation/design/sync-from-the-last-certified-commit.md
---

# Sync from the last certified commit, not HEAD: the diagram described

```text
A 1572 x 600 diagram, read top to bottom, then left to right; no bands.
Glyphs: 1 ADR-only box, 1 environment (ADR-only, framed), 2 commits; 1 ADR-only flow edge, 1 failure path; 3 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--sync-from-the-last-certified-commit--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/sync-from-the-last-certified-commit.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. There are no bands. The drawing holds one
ADR-only box, one environment hexagon (white, dashed, inside a dashed frame) and two commits, joined by one dashed flow edge and one dashed
failure path, with three markers and a legend panel along the bottom. The eye lands first on the hexagon in the middle.

## Reading path

1. Marker 1: the ADR-only box upstream integrator, top centre.
2. Down its dashed edge to marker 2: the light-blue commit `6` inside the hexagon main-UAT.
3. Right along the red dashed failure path to marker 3: the blue commit `10`, named dirty HEAD beneath it.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                  |
| ------------------------------ | ----- | ------------------------------------------------------ |
| ADR-only (box)                 | 1     | upstream integrator, top centre                        |
| environment (ADR-only, framed) | 1     | main-UAT, centre                                       |
| commit (locked palette)        | 2     | light-blue `6` inside main-UAT; blue `10` to its right |

No glyph on this diagram is structural: the environment is neutral and both commits keep their locked colours.

## Edges

| Edge kind                            | Count | From → to                 |
| ------------------------------------ | ----- | ------------------------- |
| flow: takes its commit from (dashed) | 1     | upstream integrator → `6` |
| failure path (red, dashed)           | 1     | main-UAT → `10`           |

Both edges are straight: the first vertical, the second horizontal. They do not cross.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| white hexagon     | environment: its occupant inside  |
| two commit dots   | commit (locked palette)           |
| dashed white box  | ADR-only (no code): glyph or edge |
| dashed grey arrow | flow: takes its commit from       |
| dashed red arrow  | failure path                      |
| dark disc `1`     | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--sync-from-the-last-certified-commit--meta.grid.md),
[tree](adr-dsgn-life--sync-from-the-last-certified-commit--meta.tree.md) and
[value-chain map](adr-dsgn-life--sync-from-the-last-certified-commit--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-LIFE); the explanation articles, these descriptions and the drawing tooling never light anything.

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
- **Lens badge:** META, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
