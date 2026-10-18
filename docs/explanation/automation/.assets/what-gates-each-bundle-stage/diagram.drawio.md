# Every stage of the bundle has a rule, and two gates check it: the diagram described

```text
A 1572 x 620 diagram, read left to right through three bands.
Glyphs: 1 code unit (slate), 2 gates, 2 results; 5 flow edges; 5 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../what-gates-each-bundle-stage.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
tall bands, a wide BUILD band, then BUNDLE and CODE ROOTS. It holds five glyphs (one code unit, two gates and two results) joined by five
flow edges, with five rule chips, six markers, and a legend panel along the bottom. Four glyphs sit on one horizontal line through the
middle of the bands, and a second gate sits below the code unit. The eye lands first on the two grey rhombuses (the gates) in the BUILD
band.

## Reading path

1. Marker 1, BUILD band: the code unit Build-Modules, with the rule chip `#1 #7 M5`.
2. Along the line to marker 2: the gate Assert-CatzcBundle, with the rule chip `#5` beside its upper-right side.
3. Marker 3, BUNDLE band: the result Temporary build, chip `#5`.
4. Marker 4, CODE ROOTS band: the result Installed · saved, chip `#6`.
5. Marker 5, just below the returning edge above the bands, which runs from Installed · saved back down into the top of the first gate.
6. Marker 6, BUILD band, lower left: the gate Test-CatzcBuild, chip `T30`, with an edge up into Build-Modules.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 1     | Build-Modules (BUILD band, left, on the line)                                                                                     |
| gate                  | 2     | Assert-CatzcBundle (BUILD band, right, on the line), Test-CatzcBuild (BUILD band, below Build-Modules); rhombuses with a 3 px rim |
| result                | 2     | Temporary build (BUNDLE band), Installed · saved (CODE ROOTS band, upper)                                                         |

The code unit is slate with a white name; the gates are grey and the results green.

## Edges

| Edge kind | Count | From → to                                                                                                                                         |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Build-Modules → Assert-CatzcBundle → Temporary build → Installed · saved; Test-CatzcBuild → Build-Modules; Installed · saved → Assert-CatzcBundle |

The three edges on the line are straight and horizontal, and the edge from Test-CatzcBuild is short and vertical. The returning flow edge
runs above the bands in three straight segments with one arrowhead. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                                                                |
| ----------------------- | --------------------------------------------------------------------- |
| slate rounded box       | code unit                                                             |
| grey rhombus, thick rim | gate                                                                  |
| green rounded box       | result                                                                |
| grey arrow              | flow: feeds or runs the next step                                     |
| dark disc `1`           | marker: a Walkthrough step                                            |
| white pill `#5`         | rule chip: #n ADR-AUTO-BUNDLE#n, M ADR-PWSH-MANIFEST, T ADR-AUTO-TEST |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE and ADR-PWSH-MANIFEST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
