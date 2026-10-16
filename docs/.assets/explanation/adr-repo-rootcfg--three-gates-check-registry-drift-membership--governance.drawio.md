---
catzc:
  immutable:
    with_body_sha: "7dbb8f9512f4"
    path: docs/.assets/explanation/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-repo-rootcfg-three-gates-check-registry-drift-membership-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.drawio.png
      - docs/.assets/explanation/chain/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.chain.md
      - docs/.assets/explanation/grid/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.grid.md
      - docs/.assets/explanation/tree/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.tree.md
      - docs/explanation/repository/three-gates-check-registry-drift-membership.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Three gates check the registry, the drift and the git membership: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 3 code units (slate), 1 result (green), 3 gates (neutral rhombi); 7 flow edges; 15 rule chips, 1 of them dashed; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/repository/three-gates-check-registry-drift-membership.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `SOURCE OF TRUTH`, `MATERIALISE` and `TARGET`. It holds eight glyphs, one file, three code units, one wide result and three
gates, joined by seven flow edges, with fifteen small rule chips beside the glyphs, eight markers and a legend panel along the bottom. Two
of the gates share a thin frame under the result. The eye lands first on the wide green result in the right band.

## Reading path

1. Marker 1, left band: the file "rootconfig.yml", with chips `#1` and a dashed `#2` above it.
2. Along the edge to marker 2, middle band: the gate "RootConfigFiles", with chips `#1`, `#7` and `#8` above it.
3. Marker 3: the tall code unit "Build-RootConfig", chips `#2` and `#4`; two edges leave it to the right, to marker 4, the code unit
   "Set-FileLink" (chip `#7`), and marker 5, the code unit "Write-FileIfChanged" (chips `#4` and `#5`).
4. Both edges enter marker 6, right band: the wide result "managed root files", chip `#3` at its top-right corner.
5. Down the short edge into the frame: marker 7, the gate "Test-GeneratedFiles" (chip `#6`), and marker 8, the gate "Test-RootConfigFiles"
   (chips `#3`, `#6` and `#7`).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                        |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------ |
| file                  | 1     | rootconfig.yml (left band)                                                                                   |
| code unit             | 3     | Build-RootConfig (tall), Set-FileLink, Write-FileIfChanged (middle band)                                     |
| result                | 1     | managed root files (right band, top, wide)                                                                   |
| gate                  | 3     | RootConfigFiles (middle band, left); Test-GeneratedFiles and Test-RootConfigFiles (right band, in one frame) |

The file is olive, code units slate, the result green, and the gates neutral dark rhombi with a thick light rim. The frame is chrome, not a
kind.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                        |
| ------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 7     | rootconfig.yml → RootConfigFiles, RootConfigFiles → Build-RootConfig, Build-RootConfig → Set-FileLink, Build-RootConfig → Write-FileIfChanged, Set-FileLink → managed root files, Write-FileIfChanged → managed root files, managed root files → the gates frame |

Every edge is straight, horizontal or vertical, and none crosses another. No edge carries a label.

## Rule chips

Fifteen chips, each a small pill reading `#n`, sit just above or beside the glyph the rule governs: rootconfig.yml `#1` and a dashed `#2`;
RootConfigFiles `#1`, `#7`, `#8`; Build-RootConfig `#2`, `#4`; Set-FileLink `#7`; Write-FileIfChanged `#4`, `#5`; managed root files `#3`;
Test-GeneratedFiles `#6`; Test-RootConfigFiles `#3`, `#6`, `#7`. The dashed chip is the only dashed element in the drawing.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| olive page        | file                                 |
| slate rounded box | code unit                            |
| green rounded box | result                               |
| neutral rhombus   | gate                                 |
| thin arrow        | flow: feeds the next step            |
| pill `#3`         | rule chip: ADR-REPO-ROOTCFG#n        |
| dashed pill `#2`  | dashed rule chip: ADR-only (no gate) |
| light disc `1`    | marker: a Walkthrough step           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-REPO-ROOTCFG): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](grid/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.grid.md),
[tree](tree/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.tree.md) and [value-chain map](chain/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-REPO-ROOTCFG" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
