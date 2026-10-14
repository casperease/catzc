# docs/.assets/explanation/adr-auto-bundle--what-gates-each-bundle-stage--governance.drawio.md

`Every stage has a rule, two gates check it: the diagram described`

```text
A 1572 x 620 diagram, read left to right through three bands.
Glyphs: 1 code unit (slate), 2 gates, 2 results, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 rule chips; 7 markers.
Sidebar: axis minimap (main cell AUTO x BUILD), tree minimap, lens badge GOV, map key.
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

- **Axis minimap:** the main cell is AUTO × BUILD, framed and filled in the BUILD purple with the you-are-here dot. Two touched cells, DSGN
  × LOAD and AUTO × LOAD, carry a small grey dot. The AUTO and BUILD axis labels carry a purple tick.
- **Tree minimap:** five lit tiles, labelled QualityGates, .internal, Exporter, adr/auto and adr/dsgn; the ADR files are framed in dark ink.
- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE · ADR-PWSH-MANIFEST" and "ADR-AUTO-TEST · ADR-DSGN-RUNMODE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
