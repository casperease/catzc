# docs/.assets/explanation/adr-repo-rootcfg--three-gates-check-registry-drift-membership--governance.drawio.md

`Three gates check the registry, the drift and the git membership: the diagram described`

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 3 code units (slate), 1 result (green), 3 gates (neutral rhombi); 7 flow edges; 15 rule chips, 1 of them dashed; 8 markers.
Sidebar: three minimaps and the map key.
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

The lens badge reads `GOV`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, a lit ADR file, and idle.
