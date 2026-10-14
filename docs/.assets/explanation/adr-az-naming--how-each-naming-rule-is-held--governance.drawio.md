# docs/.assets/explanation/adr-az-naming--how-each-naming-rule-is-held--governance.drawio.md

`How each naming rule is held: the diagram described`

```text
A 1572 x 820 diagram, read top to bottom through three bands.
Glyphs: 4 gates, 1 code unit (slate), 1 failure, 1 result; 5 flow edges, 5 failure paths; 5 rule chips, 6 markers.
Sidebar: axis minimap (main cell CLOUD x DEPLOY), tree minimap, lens badge GOV, map key.
```

This describes what the [diagram](adr-az-naming--how-each-naming-rule-is-held--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/how-each-naming-rule-is-held.md).

## At a glance

A 1572 × 820 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DISCOVERY, RESOLVER and NAMER. A single column of glyphs runs down the left half: four gates, one code unit and
one result, joined by five flow edges. A tall failure glyph stands on the right, spanning all three bands, and five failure paths run
straight across into it. Five rule chips sit left of the column, and six markers and a legend panel complete the drawing. The eye lands
first on the tall red failure glyph.

## Reading path

1. Marker 1, discovery band: the gate BicepShortName, with rule chip `#2` on its left.
2. Down to marker 2, resolver band: the code unit Get-BicepResourceName, with rule chip `#8`.
3. Down to marker 3, namer band: the gate registry lookups, with rule chip `#4 #5`.
4. Down to marker 4: the gate format checks, with rule chip `#1 #3 #6`.
5. Down to marker 5: the gate length limit, with rule chip `#7`, and below it the result the name.
6. Across any red edge to marker 6: the failure throw.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                      |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------- |
| gate                  | 4     | BicepShortName (discovery band); registry lookups, format checks, length limit (namer band, top to bottom) |
| code unit             | 1     | Get-BicepResourceName (resolver band)                                                                      |
| failure               | 1     | throw (right of the column, spanning all three bands)                                                      |
| result                | 1     | the name (namer band, bottom of the column)                                                                |

The code unit is slate with a white name; the gates are grey with a thick rim.

## Edges

| Edge kind    | Count | From → to                                                                                           |
| ------------ | ----- | --------------------------------------------------------------------------------------------------- |
| flow         | 5     | BicepShortName → Get-BicepResourceName → registry lookups → format checks → length limit → the name |
| failure path | 5     | each of the four gates → throw; Get-BicepResourceName → throw                                       |

Every edge is straight; the flow edges are vertical and the failure paths horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                        |
| ----------------------- | ----------------------------- |
| grey rhombus, thick rim | gate                          |
| slate rounded box       | code unit                     |
| red rounded box         | failure                       |
| green rounded box       | result                        |
| grey arrow              | flow: the next check          |
| red arrow               | failure path                  |
| white chip `#3`         | rule chip: ADR-AZ-NAMING rule |
| dark disc `1`           | marker: a Walkthrough step    |

## Sidebar

- **Axis minimap:** the main cell is CLOUD × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. One touched cell, AUTO
  × CONFIG, carries a small grey dot. The CLOUD and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** three lit tiles, labelled Az.Templates, Variants and adr/azure. The adr/azure file is framed in dark ink as an ADR file.
- **Lens badge:** GOV, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
