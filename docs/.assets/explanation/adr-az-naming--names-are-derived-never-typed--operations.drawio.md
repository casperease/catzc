---
catzc:
  derived:
    path: docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: "45b7d6cf4781"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.chain.md
      - docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.drawio.png
      - docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.grid.md
      - docs/.assets/explanation/adr-az-naming--names-are-derived-never-typed--operations.tree.md
      - docs/explanation/azure/names-are-derived-never-typed.md
---

# Names are derived, never typed: the diagram described

```text
A 1572 x 654 diagram, read top to bottom through three bands.
Glyphs: 2 files (olive), 3 code units (slate), 1 result, 1 failure; 5 flow edges, 1 failure path; 7 markers.
Sidebar: world-map grid (4 lit cells), tree (7 lit groups), value-chain map (1 lit cell), map key.
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

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-az-naming--names-are-derived-never-typed--operations.grid.md),
[tree](adr-az-naming--names-are-derived-never-typed--operations.tree.md) and
[value-chain map](adr-az-naming--names-are-derived-never-typed--operations.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AZ-NAMING); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-AZ-NAMING);
  `automation × .ps1` (7 files: 7 cite ADR-AZ-NAMING); `automation × .yml` (4 files: 4 cite ADR-AZ-NAMING); `docs × .md` (4 files: 3 cite
  ADR-AZ-NAMING; 1 is the ADR file of ADR-AZ-NAMING).
- **Tree** (the repository's files): 7 lit groups, `Az.Templates` (7 files); `Azure` (4 files); `Docs` (2 files); `adr/azure` (2 files);
  `Variants` (1 file); `adr/*` (1 file); `docs` (1 file). The ADR file `docs/adr/azure/azure-naming-standard.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `CLOUD × DEPLOY`, because ADR-AZ-NAMING: its
  ADR domain `azure` sits on the CLOUD row (ADR-DSGN-TRACK#14), and deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
