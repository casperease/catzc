# Code holds all eight naming rules, seven of them behind a check that throws: the diagram described

```text
A 1572 x 820 diagram, read top to bottom through three bands.
Glyphs: 4 gates, 1 code unit (slate), 1 failure, 1 result; 5 flow edges, 5 failure paths; 5 rule chips, 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-naming--how-each-naming-rule-is-held--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](how-each-naming-rule-is-held.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-naming--how-each-naming-rule-is-held--governance.grid.md),
[tree](../.assets/tree/adr-az-naming--how-each-naming-rule-is-held--governance.tree.md) and
[value-chain map](../.assets/chain/adr-az-naming--how-each-naming-rule-is-held--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
