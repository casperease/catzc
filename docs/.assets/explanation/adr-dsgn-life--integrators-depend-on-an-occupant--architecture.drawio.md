# docs/.assets/explanation/adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.md

`Integrators depend on the main-UAT occupant: the diagram described`

```text
A 1572 x 670 diagram, read top to bottom through three bands, with one row of hexagons in the middle band.
Glyphs: 1 ADR-only box, 4 environments (ADR-only, framed), 5 commits; 4 ADR-only flow edges, 1 failure path; 6 markers.
Sidebar: world-map grid (5 lit cells), tree (8 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/integrators-depend-on-an-occupant.md).

## At a glance

A 1572 × 670 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three full-width bands run top to bottom,
labelled EXTERNAL, PROMOTION LADDER and TIP OF MAIN. The drawing holds one ADR-only box, four environment hexagons (each white, dashed,
inside a dashed frame) and five commits, joined by four dashed flow edges and one dashed failure path, with six markers and a legend panel
along the bottom. The eye lands first on the row of four hexagons in the middle band.

## Reading path

1. Marker 1, EXTERNAL band: the ADR-only box upstream integrator, above the right-hand hexagon.
2. Down its dashed edge into the light-blue commit `6` inside main-UAT.
3. Markers 2 to 5, PROMOTION LADDER band, left to right: production (green `4`), pre-prod (green, no digit), release-uat (light-green `5`),
   main-UAT (light-blue `6`), each joined to the next by a short dashed arrow pointing right.
4. Down the red dashed failure path from main-UAT to marker 6, TIP OF MAIN band: the blue commit `10`, named dirty HEAD.

## Glyphs

| Glyph (legend phrase)          | Count | Where                                                                                                      |
| ------------------------------ | ----- | ---------------------------------------------------------------------------------------------------------- |
| ADR-only (box)                 | 1     | upstream integrator, EXTERNAL band, centred above main-UAT                                                 |
| environment (ADR-only, framed) | 4     | production, pre-prod, release-uat, main-UAT, PROMOTION LADDER band, left to right                          |
| commit (locked palette)        | 5     | green `4`, green (no digit), light-green `5`, light-blue `6` inside the hexagons; blue `10` in TIP OF MAIN |

No glyph on this diagram is structural: the environments are neutral and every commit keeps its locked colour.

## Edges

| Edge kind                            | Count | From → to                                                                                        |
| ------------------------------------ | ----- | ------------------------------------------------------------------------------------------------ |
| flow: takes its commit from (dashed) | 4     | upstream integrator → `6`; production → pre-prod; pre-prod → release-uat; release-uat → main-UAT |
| failure path (red, dashed)           | 1     | main-UAT → `10`                                                                                  |

Every edge is straight; the three in the ladder are horizontal and the other two vertical. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                            |
| ----------------- | --------------------------------- |
| white hexagon     | environment: its occupant inside  |
| four commit dots  | commit (locked palette)           |
| dashed white box  | ADR-only (no code): glyph or edge |
| dashed grey arrow | flow: takes its commit from       |
| dashed red arrow  | failure path                      |
| dark disc `1`     | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.grid.md),
[tree](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.tree.md) and
[value-chain map](adr-dsgn-life--integrators-depend-on-an-occupant--architecture.chain.md). A file or ADR lights a minimap when it cites, or
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
  `DSGN × RELEAS`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release,
  deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14),
  and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because
  ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own
  value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build,
  quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-DSGN-LIFE · ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
