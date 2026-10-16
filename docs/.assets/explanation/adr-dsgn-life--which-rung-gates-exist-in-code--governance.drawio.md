---
catzc:
  immutable:
    with_body_sha: "36c57ab09b8e"
    path: docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-which-rung-gates-exist-in-code-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md
      - docs/.assets/explanation/adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md
      - docs/explanation/design/which-rung-gates-exist-in-code.md
---

# Only PR build validation, the BVT and the failure stop are checked in code: the diagram described

```text
A 1572 x 600 diagram, read left to right along one row of gates and commits, with a second band below.
Glyphs: 8 commits, 3 gates, 4 ADR-only (3 gates, 1 runner); 4 flow, 8 ADR-only, 2 failure-path edges; 12 rule chips; 8 markers.
Sidebar: world-map grid (8 lit cells), tree (41 lit groups), value-chain map (5 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--which-rung-gates-exist-in-code--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/which-rung-gates-exist-in-code.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two full-width bands stack: `RUNG GATES` on top
and `ALL RUNGS` below. Three span bars run above them: CI, CD and DEPLOY. The top band holds one left-to-right row that alternates commits
and gates and ends with a runner; the lower band holds one wide rhombus, the gate, and one commit. The eye lands first on the two solid grey
rhombi at the left of the row, then on the three rhombi inside dashed frames.

## Reading path

1. Marker 1, top band: the gate `PR build validation`, after the brown commit `topic`.
2. Marker 2: the grey commit `landed`.
3. Marker 3: the gate `BVT`, then the yellow commit `BVT`.
4. Markers 4, 5 and 6: the ADR-only gates `L3-vertical-AT`, `RC on main-AT` and `RBC on release-AT`, each followed by its commit (blue,
   light-blue, light-green).
5. Marker 7: the ADR-only runner `two-slot activation`, then the green commit `production`.
6. Down the red line from the gate `BVT` to marker 8, lower band: the gate `failure stops downstream`, then right to the red commit
   `discarded`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| commit                | 8     | seven in the top row (brown, grey, yellow, blue, light-blue, light-green, green); one red in the lower band  |
| gate                  | 3     | `PR build validation` and `BVT` (top band), `failure stops downstream` (lower band); solid 3 px rims         |
| ADR-only              | 4     | gates `L3-vertical-AT`, `RC on main-AT`, `RBC on release-AT` (white, dashed, each in a dashed frame); runner |
|                       |       | `two-slot activation` (white dashed pill)                                                                    |

No glyph on this diagram is structural: the gates are neutral grey and every commit keeps its locked colour.

## Edges

| Edge kind    | Count | From → to                                                                                                                               |
| ------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | topic → PR build validation → landed → gate `BVT` → yellow commit                                                                       |
| ADR-only     | 8     | yellow commit → L3-vertical-AT → blue → RC on main-AT → light-blue → RBC on release-AT → light-green → two-slot activation → production |
| failure path | 2     | gate `BVT` → failure stops downstream; failure stops downstream → discarded                                                             |

The top row's twelve edges are straight and horizontal; the first failure path drops straight down. Twelve rule chips sit above the glyphs
they govern: `L1` (topic), `F8` (PR build validation), `L9` (landed), `T24` (BVT), `F5` (L3-vertical-AT), `F9` (RC on main-AT), `L6`
(main-UAT commit), `F9` and `L2` (RBC on release-AT), `F12` (two-slot activation), `L3` (production commit), and `L8` beside failure stops
downstream.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                                               | Phrase                                                     |
| ---------------------------------------------------- | ---------------------------------------------------------- |
| eight small commits, brown to green, then red        | commit (locked palette)                                    |
| grey rhombus, 3 px rim                               | gate: a check in code                                      |
| white dashed rhombus in a dashed frame, dashed arrow | ADR-only (no code)                                         |
| thin arrow                                           | flow: next rung                                            |
| red arrow                                            | failure path                                               |
| white chip `L1`                                      | rule chip: L ADR-DSGN-LIFE, F ADR-FLOW-CD, T ADR-AUTO-TEST |
| dark disc `1`                                        | marker: a Walkthrough step                                 |
| span bar                                             | span bar: stages                                           |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--which-rung-gates-exist-in-code--governance.grid.md),
[tree](adr-dsgn-life--which-rung-gates-exist-in-code--governance.tree.md) and
[value-chain map](adr-dsgn-life--which-rung-gates-exist-in-code--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-TEST, ADR-DSGN-LIFE, ADR-DSGN-VISUAL, ADR-FLOW-CD); the explanation articles, these descriptions and
the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 8 lit cells, `.claude × .md` (6 files: 6 cite ADR-AUTO-TEST,
  ADR-DSGN-LIFE, ADR-DSGN-VISUAL, ADR-FLOW-CD); `automation × .cs` (13 files: 13 cite ADR-AUTO-TEST, ADR-FLOW-CD); `automation × .ps1` (338
  files: 338 cite ADR-AUTO-TEST, ADR-FLOW-CD); `automation × .yml` (18 files: 18 cite ADR-AUTO-TEST, ADR-DSGN-LIFE, ADR-DSGN-VISUAL,
  ADR-FLOW-CD); `docs × .md` (18 files: 14 cite ADR-AUTO-TEST, ADR-DSGN-LIFE, ADR-DSGN-VISUAL, ADR-FLOW-CD; 4 are the ADR file of
  ADR-AUTO-TEST, ADR-DSGN-LIFE, ADR-DSGN-VISUAL, ADR-FLOW-CD); `pipelines × .yaml` (1 file, mentions only: 1 cites ADR-AUTO-TEST);
  `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-AUTO-TEST); `Root files × other` (2 files: 2 are mapped through
  files.yml to ADR-AUTO-TEST). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 41 lit groups, `QualityGates` (132 files); `Docs` (50 files); `Az.Templates` (29 files); `ModuleSystem`
  (20 files); `Globs` (14 files); `Azure` (11 files); `Languages` (11 files); `Maps` (11 files); `Tool.Core` (11 files); `Execution` (10
  files); `docs` (9 files); `RootConfig` (8 files); `Contracts` (7 files); `Tool.Provisioning` (7 files); `.claude` (6 files); `Reports` (5
  files); `TypesSystem` (5 files); `.internal` (4 files); `Az.DevOps` (4 files); `Tool.Inspiration` (4 files); `Root files` (3 files);
  `Config` (3 files); `ConfigExtensions` (3 files); `Exporter` (3 files); `Tool.KeyHandler` (3 files); `adr/dsgn` (3 files); `Objects` (2
  files); `Repository` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2 files); `adr/auto` (2 files); `adr/flow` (2 files);
  `.scriptanalyzer` (1 file); `Az.DevOps.BuildValidation` (1 file); `Engines` (1 file); `Environment` (1 file); `Files` (1 file); `Overlay`
  (1 file); `Timeouts` (1 file); `Tool.Python` (1 file); `pipelines` (1 file). The ADR files `docs/adr/automation/test-automation.md`,
  `docs/adr/design/commit-lifecycle.md`, `docs/adr/design/visual-design.md`, `docs/adr/flow/cd-discipline-and-promotion-flow.md` carry the
  white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 5 lit cells: `DSGN × BUILD`, because ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14),
  and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on
  the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-FLOW-CD: its
  ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control, release, deploy is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); `AUTO × QC`, because ADR-AUTO-TEST: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and
  quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE · ADR-AUTO-TEST" and "ADR-DSGN-VISUAL · ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
