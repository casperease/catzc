---
catzc:
  immutable:
    with_body_sha: ebf496b9bb58
    path: docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-thinplat-deploy-bicep-delegates-to-az-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md
      - docs/explanation/design/deploy-bicep-delegates-to-az.md
---

# Deploy-Bicep hands every vendor step to az: the diagram described

```text
A 1572 x 750 diagram, read top to bottom through four bands.
Glyphs: 1 runner, 6 code units (both slate), 1 file (olive), 2 external tools; 11 flow edges; 10 markers.
Sidebar: world-map grid (2 lit cells), tree (4 lit groups), value-chain map (2 lit cells), map key.
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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.grid.md),
[tree](adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.tree.md) and
[value-chain map](adr-dsgn-thinplat--deploy-bicep-delegates-to-az--implementation.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-THINPLAT); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (2 files: 2 cite ADR-DSGN-THINPLAT);
  `docs × .md` (3 files: 2 cite ADR-DSGN-THINPLAT; 1 is the ADR file of ADR-DSGN-THINPLAT).
- **Tree** (the repository's files): 4 lit groups, `adr/dsgn` (2 files); `Docs` (1 file); `QualityGates` (1 file); `adr/*` (1 file). The ADR
  file `docs/adr/design/thin-platforms.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-THINPLAT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-THINPLAT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
