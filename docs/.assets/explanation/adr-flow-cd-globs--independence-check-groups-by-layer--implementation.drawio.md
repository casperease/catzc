# docs/.assets/explanation/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.md

`Test-GlobSetIndependence groups by layer: the diagram described`

```text
A 1572 x 700 diagram, read top to bottom through three bands, the checks on the right.
Glyphs: 4 named sets (mauve), 2 gates (grey), 1 code unit (slate), 1 failure (red).
Edges: 4 flow, 1 failure path; 8 markers.
Sidebar: axis minimap (main cell PIPE x GLOBS), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/flow/independence-check-groups-by-layer.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. Named sets sit on the left of each band; a column of two gates and
one code unit on the right joins them, with a failure to its right. It holds four named sets, two gates, one code unit and one failure,
joined by four flow edges and one failure path, with eight markers and a legend panel. The eye lands first on the red failure in the
middle band.

## Reading path

1. Markers 1 to 4, down the left: deployable-unit sets (top band), declared loose-filesets and ReservedNames umbrellas (middle band),
   module-layer sets (bottom band).
2. Marker 5, on the right vertex of the top gate Overlaps per pair, fed from deployable-unit sets.
3. Marker 6, on the right vertex of the bottom gate Overlaps per pair, fed from module-layer sets.
4. Marker 7, the code unit Write-QualityGateReport in the middle band, which both gates feed.
5. Marker 8, the failure One throw lists every pair, at the end of the red failure path.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                 |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | deployable-unit sets (top), declared loose-filesets and ReservedNames umbrellas (middle), module-layer sets (bottom) |
| gate                  | 2     | Overlaps per pair (top band, right; bottom band, right)                                                               |
| code unit             | 1     | Write-QualityGateReport (middle band, between the gates)                                                              |
| failure               | 1     | One throw lists every pair (middle band, far right)                                                                   |

Named sets are mauve and the code unit slate, both with white names; the gates are grey rhombuses with a 3 px rim; the failure is light
red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                   |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | deployable-unit sets → top gate, module-layer sets → bottom gate, top gate → Write-QualityGateReport, bottom gate → Write-QualityGateReport |
| failure path | 1     | Write-QualityGateReport → One throw lists every pair                                                                                        |

Every edge is straight; none crosses another. The two named sets in the middle band have no edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| slate rounded box | code unit                  |
| grey rhombus      | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow, in code order        |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is PIPE × GLOBS, framed and filled in the GLOBS teal with the you-are-here dot. One touched cell,
  AUTO × GLOBS, carries a small grey dot.
- **Tree minimap:** two lit tiles, labelled Globs and adr/flow.
- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
