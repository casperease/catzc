---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.md
    kind: asset-description
    body_sha: "50a2bb16b56c"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Run-mode rules 1 to 6 each have a gate; the build kinds of rule 7 have none: the diagram described

```text
A 1572 x 690 diagram, read top to bottom through three bands.
Glyphs: 4 gates, 3 code units (slate), 1 ADR-only; 5 flow edges, 1 ADR-only edge; 8 rule chips; 8 markers.
Sidebar: world-map grid (5 lit cells), tree (13 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/which-run-mode-rules-have-a-gate.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, TEST RUNS, LOAD and AFTER THE LOAD. It holds eight glyphs, four gates, three code units and one ADR-only box, joined by
five flow edges and one ADR-only edge, with eight rule chips, eight markers and a legend panel along the bottom. The eye lands first on the
wide rhombus, the gate, in the middle of the LOAD band, which two code units point into from either side.

## Reading path

1. Markers 1 and 2, TEST RUNS band: the gates Test-Automation (left) and Test-CatzcBuild (right), each with a rule chip beside it.
2. Down from each gate to the LOAD band: marker 3, the code unit importer.ps1 (left), and marker 5, the code unit Import-Catzc.ps1 (right).
3. Marker 4, LOAD band, centre: the gate Assert-CatzcRunModeExclusive, which both code units point into.
4. Markers 6, 7 and 8, AFTER THE LOAD band, left to right: the gate Assert-SourceTree, the code unit Get-CatzcRunMode, and the ADR-only box
   Build kind. A flow edge runs from Assert-SourceTree right to Get-CatzcRunMode, and a dashed edge runs on from Get-CatzcRunMode to Build
   kind.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 4     | Test-Automation and Test-CatzcBuild (TEST RUNS), Assert-CatzcRunModeExclusive (LOAD, centre), Assert-SourceTree (AFTER THE LOAD, left) |
| code unit             | 3     | importer.ps1 and Import-Catzc.ps1 (LOAD, left and right), Get-CatzcRunMode (AFTER THE LOAD, centre)                                    |
| ADR-only              | 1     | Build kind (AFTER THE LOAD, right)                                                                                                     |

Gates are the neutral grey rhombus with a 3 px rim; code units are slate with white names; the ADR-only box is white with a dashed rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                              |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 5     | Test-Automation → importer.ps1; Test-CatzcBuild → Import-Catzc.ps1; importer.ps1 → Assert-CatzcRunModeExclusive; Import-Catzc.ps1 → Assert-CatzcRunModeExclusive; Assert-SourceTree → Get-CatzcRunMode |
| ADR-only  | 1     | Get-CatzcRunMode → Build kind                                                                                                                                                                          |

Every edge is straight, vertical or horizontal, and none crosses another.

Rule chips: `#2 · #3 · #6` beside Test-Automation, `#3 · #6` beside Test-CatzcBuild, `#1` on importer.ps1 and on Import-Catzc.ps1, `#5` on
Assert-CatzcRunModeExclusive, `#2` above Assert-SourceTree, `#4` on Get-CatzcRunMode, and `#7` on Build kind.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                             |
| ----------------------- | ---------------------------------- |
| grey rhombus, thick rim | gate                               |
| slate rounded box       | code unit                          |
| dashed white box        | ADR-only                           |
| thin arrow              | flow: calls                        |
| dashed arrow            | ADR-only (no code)                 |
| white pill `#3`         | rule chip: #n = ADR-DSGN-RUNMODE#n |
| dark disc `1`           | marker: a Walkthrough step         |
| grey band               | band: a stage                      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.grid.md),
[tree](adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.tree.md) and
[value-chain map](adr-dsgn-runmode--which-run-mode-rules-have-a-gate--governance.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never light
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
- **Lens badge:** GOV, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
