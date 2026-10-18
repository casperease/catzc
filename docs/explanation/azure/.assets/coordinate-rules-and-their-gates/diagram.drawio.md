# Two ADRs rule the coordinate; one shared check and the integrity tests hold them: the diagram described

```text
A 1572 x 660 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 2 code units (slate), 2 gates, 2 environments; 6 flow edges; 7 markers; 12 rule chips, 1 of them dashed.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../coordinate-rules-and-their-gates.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side: the narrow `CONFIGURATION` with one file, the wide `GATES` with two code units, a gate and a second gate, and the narrow
`RESOLVED` with two environments stacked. Seven glyphs, joined by six flow edges, with seven markers, twelve rule chips beside the glyphs
they govern and a legend panel along the bottom. The eye lands first on the large rhombus right of centre, the gate that four edges meet.

## Reading path

1. Marker 1, left band: the file config file, with the chips `D1`, `D2` and `C6` above its right half.
2. Up the long edge to marker 2, middle band, top: the code unit Get-BicepTemplates, chip `D8`.
3. Marker 3, middle band, bottom left: the gate shipped template integrity, chips `D3` and `D8`, whose edge runs right to marker 4: the code
   unit Assert-BicepTemplate, chip `D8`.
4. Along the two converging edges to marker 5, middle band, right: the gate Get-Bicep…ConfigViolations, chips `D3`, `C6` and `C2`.
5. Up the edge to marker 6, right band, top: the environment subscription, chip `D1`; then down to marker 7: the environment resource group,
   with the dashed chip `D5`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------- |
| file                  | 1     | config file, left band                                                                                    |
| code unit             | 2     | Get-BicepTemplates (middle band, top) and Assert-BicepTemplate (middle band, bottom)                      |
| gate                  | 2     | shipped template integrity (middle band, bottom left) and Get-Bicep…ConfigViolations (middle band, right) |
| environment           | 2     | subscription and resource group, right band, stacked                                                      |

The file is olive and the code units slate, both with white names; the gates and environments are neutral, dark with a light rim. One name
is elided in the middle with `…`; the article gives it in full. No glyph is red.

## Edges

| Edge kind                     | Count | From → to                                                                                                                                                                                       |
| ----------------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, leads to the next stage | 6     | config file → Get-BicepTemplates, shipped template integrity → Assert-BicepTemplate, Get-BicepTemplates → gate, Assert-BicepTemplate → gate, gate → subscription, subscription → resource group |

The edge from the file rises gently across the band border; the two edges into the gate on the right converge on it; the last edge is
vertical. None crosses another.

## Rule chips

Twelve chips, each a small pill beside the glyph its rule governs, lettered `D` for ADR-AZ-DATAMOD and `C` for ADR-AZ-CUSTOMER: `D1`, `D2`,
`C6` on the file; `D8` on each code unit; `D3`, `D8` on the gate of the integrity tests; `D3`, `C6`, `C2` on the gate of the shared check;
`D1` on the subscription; and `D5`, the one dashed chip, on the resource group.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                                  |
| ----------------- | ------------------------------------------------------- |
| olive page        | file                                                    |
| slate rounded box | code unit                                               |
| neutral rhombus   | gate                                                    |
| neutral hexagon   | environment                                             |
| thin arrow        | flow: leads to the next stage                           |
| light disc `1`    | marker: a Walkthrough step                              |
| pill `D3`         | rule chip: D = ADR-AZ-DATAMOD#n · C = ADR-AZ-CUSTOMER#n |
| dashed pill `D5`  | dashed rule chip: ADR-only (no gate)                    |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
