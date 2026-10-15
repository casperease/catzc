---
catzc:
  derived:
    path: docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
    kind: asset-description
    body_sha: "02fdd027ee7f"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
    links:
      - docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
      - docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.png
      - docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
      - docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
      - docs/explanation/configuration/one-gate-guards-the-read-path.md
---

# One gate guards the read path: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into two bands, with a band of gates at the bottom pointing up.
Glyphs: 2 code units (slate), 1 store (slate), 3 ADR-only boxes, 2 gates; 7 flow edges; 8 markers; 8 rule chips.
Sidebar: world-map grid (8 lit cells), tree (41 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/one-gate-guards-the-read-path.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled READ PATH, down into two bands side by side, EXTENSION POINT on the left and MISS on the right, and a full-width
band labelled QUALITY GATES at the bottom whose glyphs point up. It holds eight glyphs (two code units, one store, three ADR-only boxes and
two gates) joined by seven edges, with eight markers, eight rule chips and a legend panel along the bottom. The eye lands first on the two
dashed boxes at either end of the READ PATH band.

## Reading path

1. Markers 1 to 4, READ PATH band, left to right: the ADR-only box one reader, the code unit resolution, the store session cache and the
   ADR-only box a read, not a copy.
2. Marker 5, EXTENSION POINT band: the ADR-only box PowerShell validator.
3. Down from the store to marker 6, MISS band: the wide code unit typed once, whose right part sends an edge up into a read, not a copy.
4. Markers 7 and 8, QUALITY GATES band: the gates Test-ConfigValidators (left, edge up into PowerShell validator) and Test-ShippedConfigs
   (middle, edge up into typed once).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                              |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------- |
| code unit             | 2     | resolution (READ PATH), typed once (MISS, wide)                                                    |
| store                 | 1     | session cache (READ PATH, middle)                                                                  |
| ADR-only              | 3     | one reader and a read, not a copy (READ PATH, both ends), PowerShell validator (EXTENSION POINT)   |
| gate                  | 2     | Test-ConfigValidators and Test-ShippedConfigs (QUALITY GATES), each a grey rhombus with a 3 px rim |

Code units and the store are slate with white names; the ADR-only boxes are white with a dashed rim.

Rule chips sit on the top-right of each glyph (on the upper-right edge of a gate): `L1 L6`, `L2 A1 A2 A4`, `L3`, `A3 A5`, `L5`, `L4`,
`L5 T35` and `L4 T35`.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 7     | one reader → resolution, resolution → session cache, session cache → a read, not a copy, session cache → typed once, typed once → a read, not a copy, Test-ShippedConfigs → typed once, Test-ConfigValidators → PowerShell validator |

Every edge is straight and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                 | Phrase                                          |
| ---------------------- | ----------------------------------------------- |
| slate rounded box      | code unit                                       |
| slate cylinder         | store                                           |
| grey rhombus, 3 px rim | gate                                            |
| white dashed box       | ADR-only                                        |
| thin arrow             | flow: the read, or what a gate checks           |
| white chip `L4`        | rule chip: L LOADING, A ADDRESSING, T AUTO-TEST |
| dark disc `1`          | marker: a Walkthrough step                      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md),
[tree](adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md) and
[value-chain map](adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-AUTO-TEST, ADR-CONF-ADDRESSING, ADR-CONF-LOADING); the explanation articles, these descriptions and the
drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 8 lit cells, `.claude × .md` (4 files: 4 cite ADR-AUTO-TEST);
  `automation × .cs` (17 files: 17 cite ADR-AUTO-TEST, ADR-CONF-LOADING); `automation × .ps1` (347 files: 347 cite ADR-AUTO-TEST,
  ADR-CONF-ADDRESSING, ADR-CONF-LOADING); `automation × .yml` (17 files: 17 cite ADR-AUTO-TEST, ADR-CONF-ADDRESSING, ADR-CONF-LOADING);
  `docs × .md` (18 files: 15 cite ADR-AUTO-TEST, ADR-CONF-ADDRESSING, ADR-CONF-LOADING; 3 are the ADR file of ADR-AUTO-TEST,
  ADR-CONF-ADDRESSING, ADR-CONF-LOADING); `pipelines × .yaml` (1 file, mentions only: 1 cites ADR-AUTO-TEST); `Root files × .ps1` (1 file: 1
  is mapped through files.yml to ADR-AUTO-TEST); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-AUTO-TEST). 1 cell lit
  only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 41 lit groups, `QualityGates` (132 files); `Docs` (55 files); `Az.Templates` (30 files); `ModuleSystem`
  (20 files); `Globs` (14 files); `Languages` (13 files); `Azure` (11 files); `Execution` (11 files); `Tool.Core` (11 files); `docs` (11
  files); `Maps` (9 files); `RootConfig` (9 files); `Contracts` (7 files); `Tool.Provisioning` (7 files); `Config` (5 files); `Reports` (5
  files); `TypesSystem` (5 files); `.claude` (4 files); `.internal` (4 files); `Az.DevOps` (4 files); `Tool.Inspiration` (4 files);
  `Root files` (3 files); `ConfigExtensions` (3 files); `Exporter` (3 files); `Tool.KeyHandler` (3 files); `adr/conf` (3 files); `Git` (2
  files); `Objects` (2 files); `Repository` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2 files); `adr/auto` (2 files);
  `.scriptanalyzer` (1 file); `Az.DevOps.BuildValidation` (1 file); `Engines` (1 file); `Environment` (1 file); `Files` (1 file); `Overlay`
  (1 file); `Timeouts` (1 file); `Tool.Python` (1 file); `pipelines` (1 file). The ADR files `docs/adr/automation/test-automation.md`,
  `docs/adr/configuration/config-value-addressing.md`, `docs/adr/configuration/module-config-loading.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `AUTO × LOCAL`, because
  ADR-CONF-ADDRESSING: its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default
  concern (ADR-DSGN-TRACK#15); ADR-CONF-LOADING: its ADR domain `configuration` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is
  its ADR domain's default concern (ADR-DSGN-TRACK#15); `AUTO × QC`, because ADR-AUTO-TEST: its ADR domain `automation` sits on the AUTO row
  (ADR-DSGN-TRACK#14), and quality-control is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-CONF-LOADING" and "ADR-CONF-ADDRESSING · ADR-AUTO-TEST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
