---
catzc:
  immutable:
    with_body_sha: c4ca1369b0fc
    path: docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-globs-overlap-gated-for-units-and-modules-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md
      - docs/explanation/flow/overlap-gated-for-units-and-modules.md
---

# A gate checks overlap for units and modules: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 ADR-only (dashed white), 2 gates (grey); 3 flow edges.
Marks: 9 rule chips, 7 markers.
Sidebar: world-map grid (9 lit cells), tree (43 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/overlap-gated-for-units-and-modules.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three named sets, two ADR-only glyphs and two gates, joined
by three flow edges, with nine rule chips, seven markers and a legend panel. The eye lands first on the gate `Independence gate` at the
right of the top band and its long vertical edge down to the bottom band.

## Reading path

1. Marker 1, top band, left: the ADR-only glyph No phantom unit, chip G7.
2. Marker 2, top band: the named set deployable-unit sets, chip G10.
3. Marker 3, on the top vertex of the gate `Independence gate`, chip T35, with edges left to deployable-unit sets and down to module sets.
4. Marker 4, middle band, left: the ADR-only glyph Demonstrated use, chip G7.
5. Marker 5, middle band: the named set loose-fileset sets, chip G10, with no edge.
6. Marker 6, bottom band: the wide named set module sets, chips G7 and G10.
7. Marker 7, on the top vertex of the gate Config-load validation, chips G7 and R7, with a short edge left to module sets.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------- |
| named set             | 3     | deployable-unit sets (top), loose-fileset sets (middle), module sets (bottom, wide)    |
| ADR-only              | 2     | No phantom unit (top, left), Demonstrated use (middle, left)                           |
| gate                  | 2     | `Independence gate` (top band, right), Config-load validation (bottom band, far right) |

Named sets are mauve with white names; the ADR-only glyphs are white with a dashed rim; the gates are grey rhombuses with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                                                                           |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | `Independence gate` → deployable-unit sets, `Independence gate` → module sets, Config-load validation → module sets |

Every edge is straight and none crosses another. The two ADR-only glyphs and loose-fileset sets have no edge.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                                                     |
| ----------------- | -------------------------------------------------------------------------- |
| mauve rounded box | named set                                                                  |
| dashed white box  | ADR-only: no code checks it                                                |
| grey rhombus      | gate                                                                       |
| thin arrow        | flow: checks                                                               |
| dark disc `1`     | marker: a Walkthrough step                                                 |
| white chip `G7`   | rule chip: G = ADR-FLOW-CD-GLOBS, T = ADR-AUTO-TEST, R = ADR-REPO-PROTGLOB |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md),
[tree](adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md) and
[value-chain map](adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-PRIN-ONELIVE, ADR-REPO-PROTGLOB); the explanation articles,
these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 9 lit cells, `.claude × .md` (4 files: 4 cite ADR-AUTO-TEST,
  ADR-PRIN-ONELIVE); `.github × .yml` (1 file, mentions only: 1 cites ADR-FLOW-CD-GLOBS); `automation × .cs` (18 files: 18 cite
  ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-PRIN-ONELIVE, ADR-REPO-PROTGLOB); `automation × .ps1` (377 files: 377 cite ADR-AUTO-TEST,
  ADR-FLOW-CD-GLOBS, ADR-PRIN-ONELIVE, ADR-REPO-PROTGLOB); `automation × .yml` (19 files: 19 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS,
  ADR-PRIN-ONELIVE, ADR-REPO-PROTGLOB); `docs × .md` (20 files: 16 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-PRIN-ONELIVE,
  ADR-REPO-PROTGLOB; 4 are the ADR file of ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-PRIN-ONELIVE, ADR-REPO-PROTGLOB); `pipelines × .yaml` (6
  files: 6 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-AUTO-TEST);
  `Root files × other` (2 files: 2 are mapped through files.yml to ADR-AUTO-TEST). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 43 lit groups, `QualityGates` (138 files); `Docs` (50 files); `Globs` (49 files); `Az.Templates` (29
  files); `ModuleSystem` (19 files); `Azure` (11 files); `Languages` (11 files); `Tool.Core` (11 files); `Execution` (10 files); `docs` (10
  files); `Maps` (9 files); `RootConfig` (8 files); `Contracts` (7 files); `Tool.Provisioning` (7 files); `Az.DevOps.BuildValidation` (6
  files); `pipelines` (6 files); `Reports` (5 files); `TypesSystem` (5 files); `.claude` (4 files); `.internal` (4 files); `Az.DevOps` (4
  files); `Exporter` (4 files); `Tool.Inspiration` (4 files); `Root files` (3 files); `Config` (3 files); `ConfigExtensions` (3 files);
  `Tool.KeyHandler` (3 files); `Files` (2 files); `Objects` (2 files); `Repository` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2
  files); `adr/auto` (2 files); `adr/flow` (2 files); `adr/prin` (2 files); `adr/repo` (2 files); `.github` (1 file); `.scriptanalyzer` (1
  file); `Engines` (1 file); `Environment` (1 file); `Overlay` (1 file); `Timeouts` (1 file); `Tool.Python` (1 file). The ADR files
  `docs/adr/automation/test-automation.md`, `docs/adr/flow/durable-sha-globs.md`, `docs/adr/principles/one-living-version.md`,
  `docs/adr/repository/protected-globs.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `PRIN × RELEASE`, because ADR-PRIN-ONELIVE:
  its ADR domain `principles` sits on the PRIN row (ADR-DSGN-TRACK#14), and release is its own value-chain concern (ADR-DSGN-TRACK#15);
  `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own
  value-chain concern (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because ADR-REPO-PROTGLOB: its ADR domain `repository` sits on the AUTO row
  (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15); `AUTO × QC`, because ADR-AUTO-TEST: its ADR
  domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-FLOW-CD-GLOBS · ADR-AUTO-TEST · ADR-PRIN-ONELIVE · ADR-REPO-PROTGLOB" beneath it, on two lines.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
