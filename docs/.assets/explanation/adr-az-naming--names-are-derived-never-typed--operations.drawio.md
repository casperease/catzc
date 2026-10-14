# docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.drawio.md

`Names are derived, never typed: the diagram described`

```text
A 1572 x 654 diagram, read top to bottom through three bands.
Glyphs: 2 files (olive), 3 code units (slate), 1 result, 1 failure; 5 flow edges, 1 failure path; 7 markers.
Sidebar: axis minimap (main cell CLOUD x DEPLOY), tree minimap, lens badge OPS, map key.
```

This describes what the [diagram](adr-az-naming--names-are-derived-never-typed--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/names-are-derived-never-typed.md).

## At a glance

A 1572 × 654 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled YOU CHANGE, YOU RUN and YOU GET. It holds seven glyphs (two files, three code units, one result and one failure)
joined by five flow edges and one failure path, with seven markers and a legend panel along the bottom. The eye lands first on the wide code
unit on the right of the run band, which three edges enter.

## Reading path

1. Markers 1 and 2, change band, right half: the files variants.yml and options.yml.
2. Down their two edges to marker 4, run band, right: the code unit Get-BicepResourceName, which marker 3, the code unit Deploy-Bicep on the
   left, also feeds.
3. Down to marker 5, get band: the code unit Get-AzureResourceName.
4. Left along its edge to marker 6: the result dev-001-weu-zct-sidx-rg.
5. Down the red edge to marker 7: the failure throw.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------- |
| file                  | 2     | variants.yml, options.yml (change band, right half)                                                                    |
| code unit             | 3     | Deploy-Bicep (run band, left), Get-BicepResourceName (run band, right), Get-AzureResourceName (get band, centre right) |
| result                | 1     | dev-001-weu-zct-sidx-rg (get band, left)                                                                               |
| failure               | 1     | throw (get band, bottom right)                                                                                         |

Files are olive and code units slate, both with white names.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                                                       |
| ------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 5     | variants.yml → Get-BicepResourceName; options.yml → Get-BicepResourceName; Deploy-Bicep → Get-BicepResourceName; Get-BicepResourceName → Get-AzureResourceName; Get-AzureResourceName → dev-001-weu-zct-sidx-rg |
| failure path | 1     | Get-AzureResourceName → throw                                                                                                                                                                                   |

Every edge is straight, vertical or horizontal, and none crosses another. The edge into the result points left.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| red rounded box   | failure                    |
| grey arrow        | flow: feeds the next       |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

- **Axis minimap:** the main cell is CLOUD × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. One touched cell, AUTO
  × CONFIG, carries a small grey dot. The CLOUD and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** four lit tiles, labelled Az.Templates, Azure, Variants and adr/azure. The adr/azure file is framed in dark ink as an ADR
  file.
- **Lens badge:** OPS, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
