---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "8c792d1d34f4"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md
      - docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md
      - docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md
      - docs/explanation/automation/what-gates-each-bundle-stage.md
---

# Every stage has a rule, two gates check it: the diagram described

```text
A 1572 x 620 diagram, read left to right through three bands.
Glyphs: 1 code unit (slate), 2 gates, 2 results, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 rule chips; 7 markers.
Sidebar: world-map grid (9 lit cells), tree (43 lit groups), value-chain map (6 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/what-gates-each-bundle-stage.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
tall bands, a wide BUILD band, then BUNDLE and CODE ROOTS. It holds six glyphs (one code unit, two gates, two results and one ADR-only)
joined by five flow edges and one ADR-only edge, with six rule chips, seven markers, and a three-row legend panel along the bottom. Four
glyphs sit on one horizontal line through the middle of the bands; a second gate sits below the code unit and a dashed ADR-only glyph below
the last result. The eye lands first on the two grey rhombuses (the gates) in the BUILD band.

## Reading path

1. Marker 1, BUILD band: the code unit Build-Modules, with the rule chip `#1 #7 M5`.
2. Along the line to marker 2: the gate Assert-CatzcBundle, with the rule chip `#5` beside its upper-right side.
3. Marker 3, BUNDLE band: the result Temporary build, chip `#5`.
4. Marker 4, CODE ROOTS band: the result Installed · saved, chip `#6`.
5. Marker 5, just below the returning edge above the bands, which runs from Installed · saved back down into the top of the first gate.
6. Marker 6, CODE ROOTS band, lower: the ADR-only Cached, chip `R7`, reached by a dashed edge from Temporary build.
7. Marker 7, BUILD band, lower left: the gate Test-CatzcBuild, chip `T30`, with an edge up into Build-Modules.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 1     | Build-Modules (BUILD band, left, on the line)                                                                                     |
| gate                  | 2     | Assert-CatzcBundle (BUILD band, right, on the line), Test-CatzcBuild (BUILD band, below Build-Modules); rhombuses with a 3 px rim |
| result                | 2     | Temporary build (BUNDLE band), Installed · saved (CODE ROOTS band, upper)                                                         |
| ADR-only              | 1     | Cached (CODE ROOTS band, lower), a white box with a dashed outline                                                                |

The code unit is slate with a white name; the gates are grey and the results green.

## Edges

| Edge kind | Count | From → to                                                                                                                                         |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Build-Modules → Assert-CatzcBundle → Temporary build → Installed · saved; Test-CatzcBuild → Build-Modules; Installed · saved → Assert-CatzcBundle |
| ADR-only  | 1     | Temporary build → Cached                                                                                                                          |

The three edges on the line are straight and horizontal, and the edge from Test-CatzcBuild is short and vertical. The returning flow edge
runs above the bands in three straight segments with one arrowhead. The dashed ADR-only edge drops from the bottom of Temporary build and
turns right into Cached, in two segments. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns of up to three rows, left to right:

| Swatch                  | Phrase                                                               |
| ----------------------- | -------------------------------------------------------------------- |
| slate rounded box       | code unit                                                            |
| grey rhombus, thick rim | gate                                                                 |
| green rounded box       | result                                                               |
| white dashed box        | ADR-only                                                             |
| grey arrow              | flow: feeds or runs the next step                                    |
| dashed grey arrow       | ADR-only (no code)                                                   |
| dark disc `1`           | marker: a Walkthrough step                                           |
| white pill `#5`         | rule chip: #n ADR-AUTO-BUNDLE#n, T ADR-AUTO-TEST, R ADR-DSGN-RUNMODE |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--what-gates-each-bundle-stage--governance.grid.md),
[tree](adr-auto-bundle--what-gates-each-bundle-stage--governance.tree.md) and
[value-chain map](adr-auto-bundle--what-gates-each-bundle-stage--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-BUNDLE, ADR-AUTO-TEST, ADR-DSGN-RUNMODE, ADR-PWSH-MANIFEST); the explanation articles, these
descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 9 lit cells, `.claude × .md` (4 files: 4 cite ADR-AUTO-TEST);
  `.github × .yml` (1 file, mentions only: 1 cites ADR-AUTO-BUNDLE); `automation × .cs` (14 files: 14 cite ADR-AUTO-BUNDLE, ADR-AUTO-TEST);
  `automation × .ps1` (371 files: 371 cite ADR-AUTO-BUNDLE, ADR-AUTO-TEST, ADR-DSGN-RUNMODE, ADR-PWSH-MANIFEST); `automation × .yml` (18
  files: 18 cite ADR-AUTO-BUNDLE, ADR-AUTO-TEST, ADR-DSGN-RUNMODE, ADR-PWSH-MANIFEST); `docs × .md` (18 files: 14 cite ADR-AUTO-BUNDLE,
  ADR-AUTO-TEST, ADR-DSGN-RUNMODE, ADR-PWSH-MANIFEST; 4 are the ADR file of ADR-AUTO-BUNDLE, ADR-AUTO-TEST, ADR-DSGN-RUNMODE,
  ADR-PWSH-MANIFEST); `pipelines × .yaml` (1 file, mentions only: 1 cites ADR-AUTO-TEST); `Root files × .ps1` (1 file: 1 is mapped through
  files.yml to ADR-AUTO-BUNDLE, ADR-AUTO-TEST, ADR-DSGN-RUNMODE, ADR-PWSH-MANIFEST); `Root files × other` (2 files: 2 are mapped through
  files.yml to ADR-AUTO-TEST, ADR-DSGN-RUNMODE). 2 cells lit only by passing mentions show at 40 % ink.
- **Tree** (the repository's files): 43 lit groups, `QualityGates` (136 files); `Docs` (50 files); `Az.Templates` (29 files); `ModuleSystem`
  (25 files); `Globs` (15 files); `Exporter` (13 files); `Azure` (11 files); `Languages` (11 files); `Tool.Core` (11 files); `Execution` (10
  files); `TypesSystem` (10 files); `Maps` (9 files); `RootConfig` (9 files); `docs` (9 files); `Contracts` (8 files); `.internal` (7
  files); `Tool.Provisioning` (7 files); `Reports` (5 files); `Repository` (5 files); `.claude` (4 files); `Az.DevOps` (4 files);
  `Tool.Inspiration` (4 files); `Root files` (3 files); `Config` (3 files); `ConfigExtensions` (3 files); `Tool.KeyHandler` (3 files);
  `adr/auto` (3 files); `Objects` (2 files); `Overlay` (2 files); `Vendor` (2 files); `Tool.Toolchain` (2 files); `adr/*` (2 files);
  `adr/dsgn` (2 files); `adr/pwsh` (2 files); `.github` (1 file); `.scriptanalyzer` (1 file); `Az.DevOps.BuildValidation` (1 file);
  `Engines` (1 file); `Environment` (1 file); `Files` (1 file); `Timeouts` (1 file); `Tool.Python` (1 file); `pipelines` (1 file). The ADR
  files `docs/adr/automation/platform-bundle.md`, `docs/adr/automation/test-automation.md`, `docs/adr/design/run-modes.md`,
  `docs/adr/pwsh/dynamic-module-manifests.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 6 lit cells: `DSGN × LOCAL`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because ADR-PWSH-MANIFEST: its ADR domain `pwsh`
  sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15); `AUTO × BUILD`, because
  ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern
  (ADR-DSGN-TRACK#15); `AUTO × QC`, because ADR-AUTO-TEST: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and
  quality-control is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × RELEASE`, because ADR-AUTO-BUNDLE: its ADR domain `automation`
  sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE · ADR-PWSH-MANIFEST" and "ADR-AUTO-TEST · ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
