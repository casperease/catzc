---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: fceaa6d70d03
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md
      - docs/explanation/design/shims-set-roots-mode-read-back.md
---

# Each entry script sets the code root, and Get-CatzcRunMode reads the mode back from it: the diagram described

```text
A 1572 x 740 diagram, read top to bottom through four bands.
Glyphs: 6 code units (slate), 2 stores (slate), 1 gate, 1 failure; 6 flow edges, 1 failure path; 10 markers.
Sidebar: world-map grid (5 lit cells), tree (13 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/shims-set-roots-mode-read-back.md).

## At a glance

A 1572 × 740 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. Two bands sit
side by side at the top, SOURCE (narrow, left) and BUILD (wide, right); below them run two full-width bands, INVOKE-IMPORTER and LOAD
SEQUENCE. It holds ten glyphs, six code units, two stores, one gate and one failure, joined by six flow edges and one failure path, with ten
markers and a legend panel along the bottom. In the LOAD SEQUENCE band a thin frame encloses two code units and the gate. The eye lands
first on the wide code unit in the INVOKE-IMPORTER band, which both stores point down into, and then on the red failure at the right end of
the bottom band.

## Reading path

1. Marker 1, SOURCE band: the code unit importer.ps1, with an edge down to marker 2, the store `<RepositoryRoot>/automation`.
2. Marker 3, BUILD band: the code unit Import-Catzc.ps1, with an edge down to marker 4, the store `Catzc/<v>`.
3. Down the two edges from the stores to marker 5, the code unit Invoke-Importer, and right to marker 6, the code unit Get-CatzcRunMode.
4. Down from Invoke-Importer into the frame in the LOAD SEQUENCE band, then left to right inside it: marker 7, the code unit
   Import-VendorModules; marker 8, the code unit Import-AllModules; marker 9, the gate Assert-CatzcRunModeExclusive.
5. Along the red edge out of the frame to marker 10, the failure Exclusivity violated.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                               |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 6     | importer.ps1 (SOURCE), Import-Catzc.ps1 (BUILD), Invoke-Importer and Get-CatzcRunMode (INVOKE-IMPORTER), Import-VendorModules and Import-AllModules (LOAD SEQUENCE) |
| store                 | 2     | `<RepositoryRoot>/automation` (SOURCE), `Catzc/<v>` (BUILD)                                                                                                         |
| gate                  | 1     | Assert-CatzcRunModeExclusive (LOAD SEQUENCE)                                                                                                                        |
| failure               | 1     | Exclusivity violated (LOAD SEQUENCE, right)                                                                                                                         |

Code units and stores are slate with white names; the gate is the neutral grey rhombus with a 3 px rim; the failure is red. The frame is
chrome: no fill and a thin grey rim.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                                   |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 6     | importer.ps1 → source store; Import-Catzc.ps1 → build store; source store → Invoke-Importer; build store → Invoke-Importer; Invoke-Importer → Get-CatzcRunMode; Invoke-Importer → the frame |
| failure path | 1     | Assert-CatzcRunModeExclusive → Exclusivity violated                                                                                                                                         |

Every edge is straight, vertical or horizontal, and none crosses another. No edge runs between the three glyphs inside the frame.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                       |
| ----------------------- | ---------------------------- |
| slate rounded box       | code unit                    |
| slate cylinder          | store: a code root           |
| grey rhombus, thick rim | gate                         |
| red rounded box         | failure                      |
| thin arrow              | flow: hands on the code root |
| red arrow               | failure path                 |
| dark disc `1`           | marker: a Walkthrough step   |
| grey band               | band: a mode or a stage      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.grid.md),
[tree](adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.tree.md) and
[value-chain map](adr-dsgn-runmode--shims-set-roots-mode-read-back--implementation.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .ps1` (28 files: 28 cite ADR-DSGN-RUNMODE);
  `automation × .yml` (2 files: 2 cite ADR-DSGN-RUNMODE); `docs × .md` (3 files: 2 cite ADR-DSGN-RUNMODE; 1 is the ADR file of
  ADR-DSGN-RUNMODE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are
  mapped through files.yml to ADR-DSGN-RUNMODE).
- **Tree** (the repository's files): 13 lit groups, `ModuleSystem` (8 files); `QualityGates` (5 files); `TypesSystem` (5 files);
  `Root files` (3 files); `Repository` (3 files); `.internal` (2 files); `Docs` (2 files); `Vendor` (2 files); `adr/dsgn` (2 files);
  `ConfigExtensions` (1 file); `Globs` (1 file); `RootConfig` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/run-modes.md`
  carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
