---
catzc:
  immutable:
    with_body_sha: "88eb50a3a020"
    path: docs/.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-datamod-coordinate-rules-and-their-gates-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.png
      - docs/explanation/azure/coordinate-rules-and-their-gates.md
---

# The coordinate rules and their gates: the diagram described

```text
A 1572 x 660 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 2 code units (slate), 2 gates, 2 environments; 6 flow edges; 7 markers; 12 rule chips, 1 of them dashed.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--coordinate-rules-and-their-gates--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/coordinate-rules-and-their-gates.md).

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

The lens badge reads `GOV`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below it
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
