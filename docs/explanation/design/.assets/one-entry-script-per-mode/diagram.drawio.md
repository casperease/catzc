# Each run mode has one entry script, and a mixed session throws: the diagram described

```text
A 1572 x 720 diagram: three bands side by side over one full-width band.
Glyphs: 4 code units (slate), 2 gates, 2 failures; 4 flow edges, 2 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../one-entry-script-per-mode.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-RUNMODE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
