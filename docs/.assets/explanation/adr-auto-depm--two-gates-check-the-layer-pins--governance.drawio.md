---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.md
    kind: asset-description
    body_sha: "4e5df40b50d5"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Two gates check the layer pins: the diagram described

```text
A 1572 x 700 diagram in two columns, each read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 gates, 1 ADR-only; 3 thick edges, 1 flow edge; 6 rule chips; 6 markers.
Sidebar: world-map grid (8 lit cells), tree (39 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-depm--two-gates-check-the-layer-pins--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/two-gates-check-the-layer-pins.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two columns, each reading top to
bottom through three bands: on the left `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`; on the right `AT LOAD`, `AGAINST THE REPOSITORY` and
`NO GATE`. It holds six glyphs, three named sets, two gates and one ADR-only, joined by three thick edges and one flow edge, with six rule
chips, six markers and a legend panel along the bottom. The eye lands first on the two grey rhombi in the right column.

## Reading path

1. Markers 1, 2 and 3, left column, top to bottom: the named sets AzureExt, Tooling and Base, each with a rule chip `D3 · D4` to its right.
2. Marker 4, AT LOAD band: the gate Load check, rule chip `D4`.
3. Down the flow edge to marker 5, AGAINST THE REPOSITORY band: the gate Quality gate, rule chip `D1 · D2 · D4 · T35`.
4. Marker 6, NO GATE band: the ADR-only glyph Same-change review, dashed rule chip `D5`, joined to nothing.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| named set             | 3     | AzureExt (`TOP LAYER`), Tooling (`MIDDLE LAYER`, left), Base (`FOUNDATION`) |
| gate                  | 2     | Load check (`AT LOAD`), Quality gate (`AGAINST THE REPOSITORY`), 3 px rims  |
| ADR-only              | 1     | Same-change review (`NO GATE`), dashed outline                              |

Named sets are mauve with white names; the gates are grey rhombi and the ADR-only glyph is a white dashed box.

## Edges

| Edge kind             | Count | From → to                                           |
| --------------------- | ----- | --------------------------------------------------- |
| thick, to a named set | 3     | AzureExt → Tooling, AzureExt → Base, Tooling → Base |
| flow                  | 1     | Load check → Quality gate                           |

Every edge is straight and vertical, and none crosses another. No edge carries a chip. Six white rule chips sit beside the glyphs they
govern, one each; five are solid and the `D5` chip is dashed.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                               |
| ----------------------- | ------------------------------------ |
| mauve rounded box       | named set                            |
| grey rhombus, thick rim | gate                                 |
| dashed white box        | ADR-only                             |
| thick arrow             | may depend on, to a named set        |
| thin arrow              | flow: runs before                    |
| white chip `D4`         | rule chip: D = DEPM, T = TEST        |
| dark disc `1`           | marker: a Walkthrough step           |
| dashed white chip `D5`  | dashed rule chip: ADR-only (no gate) |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-depm--two-gates-check-the-layer-pins--governance.grid.md),
[tree](adr-auto-depm--two-gates-check-the-layer-pins--governance.tree.md) and
[value-chain map](adr-auto-depm--two-gates-check-the-layer-pins--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-DEPM, ADR-AUTO-TEST); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 8 lit cells, `.claude × .md` (4 files: 4 cite ADR-AUTO-TEST);
  `automation × .cs` (15 files: 15 cite ADR-AUTO-DEPM, ADR-AUTO-TEST); `automation × .ps1` (336 files: 336 cite ADR-AUTO-TEST);
  `automation × .yml` (17 files: 17 cite ADR-AUTO-DEPM, ADR-AUTO-TEST); `docs × .md` (14 files: 12 cite ADR-AUTO-DEPM, ADR-AUTO-TEST; 2 are
  the ADR file of ADR-AUTO-DEPM, ADR-AUTO-TEST); `pipelines × .yaml` (1 file, mentions only: 1 cites ADR-AUTO-TEST); `Root files × .ps1` (1
  file: 1 is mapped through files.yml to ADR-AUTO-TEST); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-AUTO-TEST). 1
  cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 39 lit groups, `QualityGates` (132 files); `Docs` (49 files); `Az.Templates` (29 files); `ModuleSystem`
  (22 files); `Globs` (14 files); `Azure` (11 files); `Languages` (11 files); `Tool.Core` (11 files); `Execution` (10 files); `Maps` (9
  files); `docs` (9 files); `RootConfig` (8 files); `Contracts` (7 files); `Tool.Provisioning` (7 files); `Reports` (5 files); `TypesSystem`
  (5 files); `.claude` (4 files); `.internal` (4 files); `Az.DevOps` (4 files); `Tool.Inspiration` (4 files); `Root files` (3 files);
  `Config` (3 files); `ConfigExtensions` (3 files); `Exporter` (3 files); `Tool.KeyHandler` (3 files); `adr/auto` (3 files); `Objects` (2
  files); `Repository` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2 files); `.scriptanalyzer` (1 file); `Az.DevOps.BuildValidation` (1
  file); `Engines` (1 file); `Environment` (1 file); `Files` (1 file); `Overlay` (1 file); `Timeouts` (1 file); `Tool.Python` (1 file);
  `pipelines` (1 file). The ADR files `docs/adr/automation/controlling-module-dependencies.md`, `docs/adr/automation/test-automation.md`
  carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `AUTO × LOCAL`, because ADR-AUTO-DEPM: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  `AUTO × QC`, because ADR-AUTO-TEST: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and quality-control is its own
  value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-AUTO-DEPM · ADR-AUTO-TEST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
