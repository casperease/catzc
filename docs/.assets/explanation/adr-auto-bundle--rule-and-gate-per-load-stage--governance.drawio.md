---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
    kind: asset-description
    body_sha: de4e9fb734fb
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Every load stage but the unload has an ADR rule: the diagram described

```text
A 1572 x 720 diagram, read top to bottom through six stage bands and an ADR-only frame.
Glyphs: 5 gates, 2 ADR-only; no edges; 12 rule chips; 8 markers.
Sidebar: world-map grid (8 lit cells), tree (39 lit groups), value-chain map (6 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/rule-and-gate-per-load-stage.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through six
full-width bands, one per load stage, labelled SHIM, SESSION, LOAD, RUN MODE, JANITORS and UNLOAD, under two column heads, RULES and GATE.
Beneath the bands a frame labelled ADR-ONLY holds two ADR-only glyphs. It holds seven glyphs, five gates and two ADR-only, with no edges,
twelve rule chips, eight markers and a legend panel along the bottom. The eye lands first on the column of five rhombuses in the middle of
the bands, and on the empty sixth band.

## Reading path

1. Markers 1 to 5, on the top-left corners of the first five bands: in each band, left to right, the band label, its rule chips under RULES,
   and a gate under GATE with its name beside it.
2. Marker 6, on the UNLOAD band's corner: the band holds no chip and no gate.
3. Markers 7 and 8, ADR-ONLY frame: the ADR-only glyphs build-catzc.ps1 and Write-CatzcLoadBanner, each with a rule chip `D1` to its right.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| gate                  | 5     | one per band in rows 1 to 5, each named beside it: New-Importer.Tests, code review, Import-AllModules.Tests, Assert-CatzcRunModeExclusive.Tests, Invoke-TypeCacheJanitor.Tests |
| ADR-only              | 2     | ADR-ONLY frame: build-catzc.ps1 (left), Write-CatzcLoadBanner (centre)                                                                                                         |

Gates are light grey rhombuses with a thick rim; ADR-only glyphs are white rounded boxes with a dashed rim.

## Edges

None. Each gate sits inside the band of the stage it checks, and the ADR-only glyphs stand alone in their frame.

**Rule chips:** 12 in all. SHIM: `R1`, `O1`; SESSION: `E1`, `B2`, `B8`; LOAD: `B3`, `P2`; RUN MODE: `D5`; JANITORS: `R4`, `T13`; UNLOAD:
none; the two ADR-only glyphs: `D1` each.

## Legend

A full-width panel at the bottom of the drawing area, in three columns and a full-width third row:

| Swatch                  | Phrase                                                                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| grey rhombus, thick rim | gate                                                                                                                                                    |
| dashed white box        | ADR-only                                                                                                                                                |
| white chip `#3`         | rule chip: an ADR rule on the stage                                                                                                                     |
| grey band               | band: one load stage                                                                                                                                    |
| dark disc `1`           | marker: a Walkthrough step                                                                                                                              |
| text row                | chip letters: B ADR-AUTO-BUNDLE · D ADR-DSGN-RUNMODE · E ADR-PWSH-ERROR · O ADR-PRIN-ONELIVE · P ADR-PWSH-TYPES · R ADR-REPO-ROOTCFG · T ADR-AUTO-TYPES |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md),
[tree](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md) and
[value-chain map](adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-DSGN-RUNMODE, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR, ADR-PWSH-TYPES,
ADR-REPO-ROOTCFG); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 8 lit cells, `.claude × .md` (2 files: 2 cite ADR-AUTO-TYPES,
  ADR-PRIN-ONELIVE, ADR-PWSH-ERROR); `.github × .yml` (1 file, mentions only: 1 cites ADR-AUTO-BUNDLE); `automation × .cs` (115 files: 115
  cite ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR, ADR-PWSH-TYPES, ADR-REPO-ROOTCFG); `automation × .ps1` (75 files:
  75 cite ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-DSGN-RUNMODE, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR, ADR-REPO-ROOTCFG); `automation × .yml` (10
  files: 10 cite ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-DSGN-RUNMODE, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR, ADR-PWSH-TYPES, ADR-REPO-ROOTCFG);
  `docs × .md` (21 files: 14 cite ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-DSGN-RUNMODE, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR, ADR-PWSH-TYPES,
  ADR-REPO-ROOTCFG; 7 are the ADR file of ADR-AUTO-BUNDLE, ADR-AUTO-TYPES, ADR-DSGN-RUNMODE, ADR-PRIN-ONELIVE, ADR-PWSH-ERROR,
  ADR-PWSH-TYPES, ADR-REPO-ROOTCFG); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-AUTO-BUNDLE, ADR-AUTO-TYPES,
  ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-AUTO-TYPES, ADR-DSGN-RUNMODE). 1 cell lit only by
  passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 39 lit groups, `Docs` (30 files); `QualityGates` (22 files); `Maps` (20 files); `ModuleSystem` (16
  files); `Languages` (12 files); `VSCode` (12 files); `Exporter` (11 files); `Azure` (9 files); `TypesSystem` (9 files); `RootConfig` (8
  files); `docs` (8 files); `Contracts` (7 files); `Az.Templates` (5 files); `Repository` (5 files); `.internal` (4 files); `Reports` (4
  files); `Root files` (3 files); `Git` (3 files); `Variants` (3 files); `Vendor` (3 files); `adr/auto` (3 files); `adr/pwsh` (3 files);
  `.claude` (2 files); `Az.DevOps.BuildValidation` (2 files); `Files` (2 files); `Objects` (2 files); `Timeouts` (2 files);
  `Tool.Inspiration` (2 files); `Tool.KeyHandler` (2 files); `adr/dsgn` (2 files); `adr/prin` (2 files); `adr/repo` (2 files); `.github` (1
  file); `.scriptanalyzer` (1 file); `Az.DevOps` (1 file); `ConfigExtensions` (1 file); `Engines` (1 file); `Globs` (1 file); `adr/*` (1
  file). The ADR files `docs/adr/automation/BCL/native-csharp-types.md`, `docs/adr/automation/platform-bundle.md`,
  `docs/adr/design/run-modes.md`, `docs/adr/principles/one-living-version.md`, `docs/adr/pwsh/error-handling.md` and 2 more (listed in the
  tree description) carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 6 lit cells: `PRIN × RELEASE`, because ADR-PRIN-ONELIVE:
  its ADR domain `principles` sits on the PRIN row (ADR-DSGN-TRACK#14), and release is its own value-chain concern (ADR-DSGN-TRACK#15);
  `DSGN × LOCAL`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its
  own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because ADR-AUTO-TYPES:
  its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); ADR-PWSH-ERROR: its ADR domain `pwsh` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's
  default concern (ADR-DSGN-TRACK#15); ADR-PWSH-TYPES: its ADR domain `pwsh` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation, build
  is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-REPO-ROOTCFG: its ADR domain `repository` sits on the AUTO row
  (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15); `AUTO × BUILD`, because ADR-AUTO-BUNDLE: its
  ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern (ADR-DSGN-TRACK#15);
  ADR-AUTO-TYPES: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); ADR-PWSH-TYPES: its ADR domain `pwsh` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation, build is its own
  value-chain concern (ADR-DSGN-TRACK#15); `AUTO × RELEASE`, because ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row
  (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV. Beneath it, four lines at 10.5 px read "Supports ADR-AUTO-BUNDLE · ADR-PWSH-ERROR", "ADR-AUTO-TYPES ·
  ADR-PWSH-TYPES", "ADR-DSGN-RUNMODE · ADR-PRIN-ONELIVE" and "ADR-REPO-ROOTCFG".
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
