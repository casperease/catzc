# docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md

`Deploy-Bicep hands every vendor step to az: the diagram described`

```text
A 1572 x 750 diagram, read top to bottom through four bands.
Glyphs: 1 runner, 6 code units (both slate), 1 file (olive), 2 external tools; 11 flow edges; 10 markers.
Sidebar: axis minimap (main cell DSGN x DEPLOY), tree minimap, lens badge IMPL, map key.
```

This describes what the [diagram](adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/deploy-bicep-delegates-to-az.md).

## At a glance

A 1572 × 750 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled CONSUMERS, CLI SURFACE, CATZC and DELEGATED; inside the CATZC band four code units sit in one row. It holds ten
glyphs (one runner, six code units, one file and two external tools) joined by eleven flow edges, with ten markers and a legend panel along
the bottom. The eye lands first on the wide code unit Deploy-Bicep in the CLI SURFACE band.

## Reading path

1. Markers 1 and 2, CONSUMERS band: the runner AzureCLI@2 (left of centre) and the code unit Connect-AzCli (far right).
2. Marker 3, CLI SURFACE band: the code unit Deploy-Bicep, entered from marker 1; marker 4: the file azure.yml · options.yml to its left.
3. CATZC band: marker 5, Get-BicepDeploymentContext, below Deploy-Bicep; marker 6, Get-AzCliSessionSubscription, to its left under the file;
   then right to marker 7, Build-Bicep, and marker 8, Invoke-AzCli.
4. DELEGATED band: marker 9, the external tool az CLI, entered from Invoke-AzCli and by the long edge from Connect-AzCli; marker 10, the
   external tool Bicep, to its left.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                              |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| runner                | 1     | AzureCLI@2 (CONSUMERS)                                                                                                                             |
| code unit             | 6     | Connect-AzCli (CONSUMERS), Deploy-Bicep (CLI SURFACE), Get-AzCliSessionSubscription, Get-BicepDeploymentContext, Build-Bicep, Invoke-AzCli (CATZC) |
| file                  | 1     | azure.yml · options.yml (CLI SURFACE, left)                                                                                                        |
| external tool         | 2     | Bicep and az CLI (DELEGATED)                                                                                                                       |

The runner (a pill) and the code units (rounded boxes) are both slate, told apart by shape; the file is olive. All three carry white names.
The external tools are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                                              |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 11    | AzureCLI@2 → Deploy-Bicep; Deploy-Bicep → file, → Get-BicepDeploymentContext, → Invoke-AzCli; Get-BicepDeploymentContext → Get-AzCliSessionSubscription, → Build-Bicep; Get-AzCliSessionSubscription → file; Build-Bicep → Invoke-AzCli; Invoke-AzCli → az CLI; Connect-AzCli → az CLI; az CLI → Bicep |

Every edge is straight, horizontal or vertical, and none crosses another or a glyph.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate pill        | runner                     |
| slate rounded box | code unit                  |
| olive folded page | file                       |
| grey square box   | external tool              |
| grey arrow        | flow: uses                 |
| dark disc `1`     | marker: a Walkthrough step |
| grey band         | band: one layer            |

## Sidebar

- **Axis minimap:** the main cell is DSGN × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. Six touched cells carry
  a small grey dot: AUTO × BUILD, PIPE × LOAD, PIPE × DEPLOY, CLOUD × CONFIG, CLOUD × DEPLOY and CLOUD × ACCESS.
- **Tree minimap:** lit tiles labelled Tool.Core, Az.Cli, Azure, Az.Templates, adr/dsgn, pipelines and infrastructure.
- **Lens badge:** IMPL, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
