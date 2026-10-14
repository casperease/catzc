# docs/.assets/explanation/adr-dsgn-runmode--one-entry-script-per-mode--operations.drawio.md

`Each run mode has one entry script, and a mixed session throws: the diagram described`

```text
A 1572 x 720 diagram: three bands side by side over one full-width band.
Glyphs: 4 code units (slate), 2 gates, 2 failures; 4 flow edges, 2 failure paths; 8 markers.
Sidebar: axis minimap (main cell DSGN x LOAD), tree minimap, lens badge OPS, map key.
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

- **Axis minimap:** the main cell is DSGN × LOAD, framed and filled in the LOAD blue with the you-are-here dot. Four touched cells, AUTO ×
  LOAD, AUTO × CONFIG, AUTO × BUILD and AUTO × ACCESS, carry a small grey dot. The DSGN and LOAD axis labels carry a blue tick.
- **Tree minimap:** lit tiles labelled .internal, Repository, RootConfig, Exporter, adr/dsgn and (root). The adr/dsgn file is framed in dark
  ink as an ADR file.
- **Lens badge:** OPS, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
