---
catzc:
  immutable:
    with_body_sha: cd85d597101c
    path: docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-runmode-one-entry-script-per-mode-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md
      - docs/explanation/design/one-entry-script-per-mode.md
---

# Each run mode has one entry script, and a mixed session throws: the diagram described

```text
A 1572 x 720 diagram: three bands side by side over one full-width band.
Glyphs: 4 code units (slate), 2 gates, 2 failures; 4 flow edges, 2 failure paths; 8 markers.
Sidebar: world-map grid (5 lit cells), tree (13 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/one-entry-script-per-mode.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three tall bands sit side by side at the top,
SOURCE (left), IMPORTER TAIL (centre) and BUILD (right); a full-width band, WHEN IT STOPS, runs below them. It holds eight glyphs, four code
units, two gates and two failures, joined by four flow edges and two failure paths, with eight markers and a legend panel along the bottom.
The eye lands first on the wide rhombus, the gate, in the IMPORTER TAIL band, which code units point into from both sides, and follows its
red edge down to a failure.

## Reading path

1. Marker 1, SOURCE band: the code unit `. ./importer.ps1`, with an edge right into the gate.
2. Markers 2, 3 and 4, BUILD band, top to bottom: the code units Import-Module Catzc, `. Import-Catzc.ps1` and `. <dir>/importer.ps1`. The
   top and bottom ones each point into the middle one, which points left into the gate.
3. Marker 5, IMPORTER TAIL band: the gate Assert-CatzcRunModeExclusive, and down its red edge to marker 6, the failure
   `Exclusivity violated`, in the WHEN IT STOPS band.
4. Marker 7, WHEN IT STOPS band, right: the gate Assert-SourceTree, with no edge in, and along a short red edge to marker 8, the failure
   `Source tree only`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                           |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------- |
| code unit             | 4     | `. ./importer.ps1` (SOURCE); Import-Module Catzc, `. Import-Catzc.ps1`, `. <dir>/importer.ps1` (BUILD, stacked) |
| gate                  | 2     | Assert-CatzcRunModeExclusive (IMPORTER TAIL), Assert-SourceTree (WHEN IT STOPS, right)                          |
| failure               | 2     | Exclusivity violated (WHEN IT STOPS, centre), Source tree only (WHEN IT STOPS, far right)                       |

Code units are slate with white names; gates are the neutral grey rhombus with a 3 px rim; failures are red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                                         |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | Import-Module Catzc → `. Import-Catzc.ps1`; `. <dir>/importer.ps1` → `. Import-Catzc.ps1`; `. ./importer.ps1` → Assert-CatzcRunModeExclusive; `. Import-Catzc.ps1` → Assert-CatzcRunModeExclusive |
| failure path | 2     | Assert-CatzcRunModeExclusive → Exclusivity violated; Assert-SourceTree → Source tree only                                                                                                         |

Every edge is straight, vertical or horizontal, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| red rounded box         | failure                    |
| thin arrow              | flow: hands the load on to |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: a mode or a stage    |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-runmode--one-entry-script-per-mode--operations.grid.md),
[tree](adr-dsgn-runmode--one-entry-script-per-mode--operations.tree.md) and
[value-chain map](adr-dsgn-runmode--one-entry-script-per-mode--operations.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never light anything.

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
- **Lens badge:** OPS, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
