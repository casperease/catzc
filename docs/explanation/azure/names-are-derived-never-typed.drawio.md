---
catzc:
  immutable:
    with_body_sha: "2c27c83d30c3"
    repo_status: clean
    path: docs/explanation/azure/names-are-derived-never-typed.drawio.md
    folder: docs/explanation/azure
    name: names-are-derived-never-typed-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-az-naming--names-are-derived-never-typed--operations.drawio.png
      - docs/explanation/.assets/chain/adr-az-naming--names-are-derived-never-typed--operations.chain.md
      - docs/explanation/.assets/grid/adr-az-naming--names-are-derived-never-typed--operations.grid.md
      - docs/explanation/.assets/tree/adr-az-naming--names-are-derived-never-typed--operations.tree.md
      - docs/explanation/azure/names-are-derived-never-typed.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Names are derived, never typed: the diagram described

```text
A 1572 x 654 diagram, read top to bottom through three bands.
Glyphs: 2 files (olive), 3 code units (slate), 1 result, 1 failure; 5 flow edges, 1 failure path; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-naming--names-are-derived-never-typed--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](names-are-derived-never-typed.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-naming--names-are-derived-never-typed--operations.grid.md),
[tree](../.assets/tree/adr-az-naming--names-are-derived-never-typed--operations.tree.md) and
[value-chain map](../.assets/chain/adr-az-naming--names-are-derived-never-typed--operations.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** OPS, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
