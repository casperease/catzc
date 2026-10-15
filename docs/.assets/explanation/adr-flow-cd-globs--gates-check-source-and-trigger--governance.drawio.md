---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.md
    kind: asset-description
    body_sha: fb6e7675d761
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md
      - docs/explanation/flow/gates-check-source-and-trigger.md
---

# Gates check the source and the trigger only: the diagram described

```text
A 1572 x 640 diagram, read left to right through five bands.
Glyphs: 1 file (olive), 4 code units (slate), 3 gates; 7 flow edges; 8 markers, 8 rule chips.
Sidebar: world-map grid (9 lit cells), tree (42 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/flow/gates-check-source-and-trigger.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through five
bands side by side, labelled `SOURCE`, `LOAD`, `FLATTEN`, `ROLES` and `CHECKED BY`. It holds eight glyphs, one file, four code units and
three gates, joined by seven edges, with eight markers, eight rule chips and a legend panel along the bottom. The eye lands first on the
tall code unit in the FLATTEN band, then on the two empty rows of the CHECKED BY band.

## Reading path

1. Marker 1, SOURCE band, middle row: the file Registry.
2. Down its edge to marker 2, SOURCE band, bottom: the gate Test-GlobSetIndependence, marked at its left vertex.
3. Right from Registry to marker 3, LOAD band: the gate Config load, marked at its top vertex.
4. Right to marker 4, FLATTEN band: the tall code unit Scan program.
5. Right along three parallel edges to the ROLES band: marker 5 on Native projection (top row), then its edge to marker 6, the gate
   `Trigger gates` in the CHECKED BY band, marked at its top vertex.
6. Markers 7 and 8, ROLES band: the code units Git reflection (middle row) and Live identity (bottom row). No edge leaves either; the
   CHECKED BY band is empty in their rows.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                               |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | Registry (SOURCE band, middle row)                                                                                  |
| gate                  | 3     | Test-GlobSetIndependence (SOURCE band, bottom), Config load (LOAD band), `Trigger gates` (CHECKED BY band, top row) |
| code unit             | 4     | Scan program (FLATTEN band, all rows); Native projection, Git reflection, Live identity (ROLES band, one per row)   |

The file is olive and the code units are slate, both with white names. Every gate is grey with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                 |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | Registry → Test-GlobSetIndependence (down); Registry → Config load → Scan program; Scan program → each of the three ROLES code units; Native projection → `Trigger gates` |

Every edge is straight; none crosses another.

## Rule chips

Eight white chips sit on the top edge of the glyph they govern: G1 · G7 · G10 (Registry), G10 · T35 (Test-GlobSetIndependence), G3 · G8
(Config load), G2 · G4 · G8 (Scan program), G6 (Native projection), G9 (Git reflection), G5 (Live identity) and G6 · T35 (`Trigger gates`).

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                                              |
| ---------------------- | --------------------------------------------------- |
| olive folded page      | file                                                |
| slate rounded box      | code unit                                           |
| grey rhombus, 3 px rim | gate                                                |
| thin arrow             | flow: output read by the next                       |
| white chip `G6`        | rule chip: G = ADR-FLOW-CD-GLOBS, T = ADR-AUTO-TEST |
| dark disc `1`          | marker: a Walkthrough step                          |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md),
[tree](adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md) and
[value-chain map](adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB); the explanation articles, these descriptions and the
drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 9 lit cells, `.claude × .md` (4 files: 4 cite ADR-AUTO-TEST);
  `.github × .yml` (1 file, mentions only: 1 cites ADR-FLOW-CD-GLOBS); `automation × .cs` (17 files: 17 cite ADR-AUTO-TEST,
  ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB); `automation × .ps1` (376 files: 376 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB);
  `automation × .yml` (19 files: 19 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB); `docs × .md` (18 files: 15 cite
  ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB; 3 are the ADR file of ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS, ADR-REPO-PROTGLOB);
  `pipelines × .yaml` (6 files: 6 cite ADR-AUTO-TEST, ADR-FLOW-CD-GLOBS); `Root files × .ps1` (1 file: 1 is mapped through files.yml to
  ADR-AUTO-TEST); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-AUTO-TEST). 1 cell lit only by passing mentions shows
  at 40 % ink.
- **Tree** (the repository's files): 42 lit groups, `QualityGates` (138 files); `Docs` (49 files); `Globs` (49 files); `Az.Templates` (29
  files); `ModuleSystem` (19 files); `Azure` (11 files); `Languages` (11 files); `Tool.Core` (11 files); `Execution` (10 files); `docs` (10
  files); `Maps` (9 files); `RootConfig` (8 files); `Contracts` (7 files); `Tool.Provisioning` (7 files); `Az.DevOps.BuildValidation` (6
  files); `pipelines` (6 files); `Reports` (5 files); `TypesSystem` (5 files); `.claude` (4 files); `.internal` (4 files); `Az.DevOps` (4
  files); `Exporter` (4 files); `Tool.Inspiration` (4 files); `Root files` (3 files); `Config` (3 files); `ConfigExtensions` (3 files);
  `Tool.KeyHandler` (3 files); `Objects` (2 files); `Repository` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2 files); `adr/auto` (2
  files); `adr/flow` (2 files); `adr/repo` (2 files); `.github` (1 file); `.scriptanalyzer` (1 file); `Engines` (1 file); `Environment` (1
  file); `Files` (1 file); `Overlay` (1 file); `Timeouts` (1 file); `Tool.Python` (1 file). The ADR files
  `docs/adr/automation/test-automation.md`, `docs/adr/flow/durable-sha-globs.md`, `docs/adr/repository/protected-globs.md` carry the white
  rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 3 lit cells: `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15);
  `AUTO × LOCAL`, because ADR-REPO-PROTGLOB: its ADR domain `repository` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR
  domain's default concern (ADR-DSGN-TRACK#15); `AUTO × QC`, because ADR-AUTO-TEST: its ADR domain `automation` sits on the AUTO row
  (ADR-DSGN-TRACK#14), and quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-FLOW-CD-GLOBS" and "ADR-AUTO-TEST · ADR-REPO-PROTGLOB" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
