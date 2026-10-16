---
catzc:
  immutable:
    with_body_sha: "98d3a39c5b0c"
    path: docs/.assets/explanation/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-repo-rootcfg-opted-in-then-link-copy-or-render-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.chain.md
      - docs/.assets/explanation/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.drawio.png
      - docs/.assets/explanation/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.grid.md
      - docs/.assets/explanation/adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.tree.md
      - docs/explanation/repository/opted-in-then-link-copy-or-render.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The optIn filter, then link, copy or render: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 6 code units (slate), 1 failure (red), 2 results (green); 9 flow edges, 1 failure path; 3 fraction chips; 10 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/repository/opted-in-then-link-copy-or-render.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `SOURCE OF TRUTH`, a wide `MATERIALISE` and `TARGET`. It holds ten glyphs, one file, six code units, one failure and two
results, joined by nine flow edges and one failure path, with three fraction chips, ten markers and a legend panel along the bottom. The eye
lands first on the single red failure glyph under the second code unit, then follows the top row to the right.

## Reading path

1. Marker 1, left band: the file "rootconfig.yml".
2. Marker 2, middle band, top row: the code unit "RootConfigFiles"; the red failure path drops from it to marker 3, the failure "validation
   failed".
3. Marker 4, top row: the code unit "Get-RootConfigTargets"; then marker 5: the tall code unit "Build-RootConfig".
4. Three edges leave Build-RootConfig to the right, each with a fraction chip above it: 7/23 to marker 6, the code unit "Set-FileLink";
   10/23 to marker 7, "Get-RootConfigRenderedFile"; 6/23 to marker 8, "Write-FileIfChanged". A vertical edge drops from
   Get-RootConfigRenderedFile to Write-FileIfChanged.
5. Marker 9, right band, top: the result "link to the source", entered from Set-FileLink; marker 10, bottom: the result "independent file",
   entered from Write-FileIfChanged.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                        |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | rootconfig.yml (left band)                                                                                                                   |
| code unit             | 6     | RootConfigFiles, Get-RootConfigTargets, Build-RootConfig (tall), Set-FileLink, Get-RootConfigRenderedFile, Write-FileIfChanged (middle band) |
| failure               | 1     | validation failed (middle band, under RootConfigFiles)                                                                                       |
| result                | 2     | link to the source (right band, top), independent file (right band, bottom)                                                                  |

The file is olive, code units slate, the failure red and the results green, all with light names.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                                                                                                                                |
| ------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow, calls the next step | 9     | rootconfig.yml → RootConfigFiles, RootConfigFiles → Get-RootConfigTargets, Get-RootConfigTargets → Build-RootConfig, Build-RootConfig → Set-FileLink, Build-RootConfig → Get-RootConfigRenderedFile, Build-RootConfig → Write-FileIfChanged, Get-RootConfigRenderedFile → Write-FileIfChanged, Set-FileLink → link to the source, Write-FileIfChanged → independent file |
| failure path              | 1     | RootConfigFiles → validation failed                                                                                                                                                                                                                                                                                                                                      |

Every edge is straight, horizontal or vertical, and none crosses another. The three short edges leaving Build-RootConfig each have a bold
fraction chip just above them: 7/23, 10/23 and 6/23.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                  |
| ----------------- | --------------------------------------- |
| olive page        | file                                    |
| slate rounded box | code unit                               |
| green rounded box | result                                  |
| red rounded box   | failure                                 |
| thin arrow        | flow: calls the next step               |
| red arrow         | failure path                            |
| bold `7/23`       | fraction chip: entries taking this edge |
| light disc `1`    | marker: a Walkthrough step              |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-ROOTCFG): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.grid.md),
[tree](adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.tree.md) and [value-chain map](adr-repo-rootcfg--opted-in-then-link-copy-or-render--implementation.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-REPO-ROOTCFG" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
