# docs/.assets/explanation/adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.md

`The CI budget is the only promotion rule a quality gate checks: the diagram described`

```text
A 1572 x 600 diagram, read left to right along a FLOW band, with a CHECKS band below it.
Glyphs: 4 runners (2 slate, 2 ADR-only), 3 gates (1 solid, 2 ADR-only), 1 actor; 7 rule chips; 1 flow and 1 ADR-only edge; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (11 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/ci-budget-is-the-only-quality-gate.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a top band
labelled FLOW, with a second full-width band labelled CHECKS below it. Three span bars sit above the bands: CD and DEPLOY on the upper row,
CI on the lower row. It holds eight glyphs (four runners, three gates and one actor), seven rule chips, eight markers, and a legend panel
along the bottom. The glyphs in the FLOW band stand in one row with no edges between them. The eye lands first on the two slate runners at
the left of the FLOW band.

## Reading path

1. Marker 1, FLOW band: the runner CI inner loop, solid chip `#2`.
2. Marker 2, CHECKS band: the gate `machine gate`, solid chip `#13`, with its edge up into CI inner loop.
3. Marker 3, FLOW band: the runner CD, dashed chip `#5`.
4. Marker 4: the gate RC, thin dashed rim, in a dashed frame, dashed chip `#9`.
5. Marker 5: the dashed white runner DEPLOY-Non-Prod, dashed chip `#11`.
6. Marker 6: the gate RBC, thin dashed rim, in a dashed frame, dashed chip `#9`.
7. Marker 7: the dashed white runner DEPLOY-Prod, dashed chip `#12`.
8. Marker 8, CHECKS band: the actor reviewer, with a dashed edge up to the FLOW band.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                               |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| runner                | 4     | CI inner loop and CD (solid, slate), DEPLOY-Non-Prod and DEPLOY-Prod (ADR-only: dashed, white), in FLOW             |
| gate                  | 3     | `machine gate` (CHECKS, left, solid grey, 3 px rim); RC, RBC (FLOW, ADR-only: white, thin dashed rim, dashed frame) |
| actor                 | 1     | reviewer (CHECKS, centre)                                                                                           |

## Edges

| Edge kind | Count | From → to                                        |
| --------- | ----- | ------------------------------------------------ |
| flow      | 1     | `machine gate` → CI inner loop (upward)          |
| ADR-only  | 1     | reviewer → the FLOW band's lower border (upward) |

Both edges are straight and vertical. Seven rule chips sit on the upper right of their glyphs: `#2` and `#13` solid; `#5`, `#9`, `#11`, `#9`
and `#12` dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                         |
| ----------------------- | ---------------------------------------------- |
| slate pill              | runner                                         |
| grey rhombus, thick rim | gate                                           |
| white circle            | actor                                          |
| white chip `#5`         | rule chip: ADR-FLOW-CD rule                    |
| solid arrow             | flow: checks                                   |
| dashed arrow            | ADR-only (no code): dashed line, frame or chip |
| span bar                | span bar: stages over bands                    |
| dark disc `1`           | marker: a Walkthrough step                     |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.grid.md),
[tree](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.tree.md) and
[value-chain map](adr-flow-cd--ci-budget-is-the-only-quality-gate--governance.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-FLOW-CD, ADR-FLOW-CD-TYPE); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.claude × .md` (1 file: 1 cites ADR-FLOW-CD);
  `automation × .cs` (4 files: 4 cite ADR-FLOW-CD, ADR-FLOW-CD-TYPE); `automation × .ps1` (8 files: 8 cite ADR-FLOW-CD, ADR-FLOW-CD-TYPE);
  `automation × .yml` (4 files: 4 cite ADR-FLOW-CD, ADR-FLOW-CD-TYPE); `docs × .md` (5 files: 3 cite ADR-FLOW-CD, ADR-FLOW-CD-TYPE; 2 are
  the ADR file of ADR-FLOW-CD, ADR-FLOW-CD-TYPE); `pipelines × .yaml` (2 files: 2 cite ADR-FLOW-CD-TYPE).
- **Tree** (the repository's files): 11 lit groups, `Az.DevOps.BuildValidation` (6 files); `Docs` (3 files); `Maps` (3 files); `adr/flow` (3
  files); `adr/*` (2 files); `pipelines` (2 files); `.claude` (1 file); `Az.DevOps` (1 file); `Az.Templates` (1 file); `ModuleSystem` (1
  file); `QualityGates` (1 file). The ADR files `docs/adr/flow/cd-discipline-and-promotion-flow.md`, `docs/adr/flow/pipeline-types.md` carry
  the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD-TYPE: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control,
  release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-FLOW-CD: its ADR domain `flow` sits on
  the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  ADR-FLOW-CD-TYPE: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR
  domain's default concern (ADR-DSGN-TRACK#15); `DSGN × RELEAS`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  ADR-FLOW-CD-TYPE: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR
  domain's default concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-FLOW-CD: its ADR domain `flow` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  ADR-FLOW-CD-TYPE: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR
  domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-FLOW-CD · ADR-FLOW-CD-TYPE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
