# docs/.assets/explanation/adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.md

`Every vendor call leaves cats through the az CLI: the diagram described`

```text
A 1572 x 802 diagram, read top to bottom through four bands.
Glyphs: 3 code units (slate), 1 file (olive), 2 external tools, 1 environment; 7 flow edges; 8 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-dsgn-thinplat--every-vendor-call-leaves-through-az--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/design/every-vendor-call-leaves-through-az.md).

## At a glance

A 1572 × 802 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled CLI SURFACE, CATZC, DELEGATED and VENDOR SUBSTRATE. It holds seven glyphs (three code units, one file, two
external tools and one environment) joined by seven flow edges, with eight markers and a legend panel along the bottom. The eye lands first
on the slate code unit in the CATZC band, which three edges leave.

## Reading path

1. Marker 1, CLI SURFACE band: the code unit Catzc.Azure.Templates, left of centre.
2. Right along its edge to marker 2: the file azure.yml · options.yml.
3. Down from marker 1 to marker 3, CATZC band: the code unit Catzc.Azure.Cli, with an edge back up into the file.
4. Right to marker 4: the code unit Catzc.Tooling.Core.
5. Down from marker 3 to marker 5, DELEGATED band: the external tool az CLI, and right to marker 6: the external tool Bicep.
6. Down the edge carrying marker 8, which sits beside the line, to marker 7, VENDOR SUBSTRATE band: the environment Azure.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                               |
| --------------------- | ----- | ----------------------------------------------------------------------------------- |
| code unit             | 3     | Catzc.Azure.Templates (CLI SURFACE), Catzc.Azure.Cli and Catzc.Tooling.Core (CATZC) |
| file                  | 1     | azure.yml · options.yml (CLI SURFACE, right)                                        |
| external tool         | 2     | az CLI and Bicep (DELEGATED)                                                        |
| environment           | 1     | Azure (VENDOR SUBSTRATE, under az CLI)                                              |

Code units are slate and the file is olive, both with white names; the external tools and the environment are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                       |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | Templates → file, Templates → Cli, Cli → file, Cli → Tooling.Core, Cli → az CLI, az CLI → Bicep, az CLI → Azure |

Every edge is straight, horizontal or vertical, and none crosses another. Only one edge enters Azure.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| olive folded page | file                       |
| grey square box   | external tool              |
| grey hexagon      | environment                |
| grey arrow        | flow: uses                 |
| dark disc `1`     | marker: a Walkthrough step |
| grey band         | band: one layer            |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Four touched cells carry
  a small grey dot: AUTO × BUILD, AUTO × ACCESS, CLOUD × CONFIG and CLOUD × DEPLOY.
- **Tree minimap:** lit tiles labelled Tool.Core, Azure, Az.Templates, adr/auto, adr/dsgn, .claude and infrastructure.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-THINPLAT · ADR-AZ-CLI" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
