---
catzc:
  immutable:
    with_body_sha: c8de989c7cd4
    path: docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-naming-one-namer-assembles-every-name-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
      - docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.png
      - docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
      - docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.tree.md
      - docs/explanation/azure/one-namer-assembles-every-name.md
---

# One namer assembles every Azure name: the diagram described

```text
A 1572 x 750 diagram, read top to bottom through four bands.
Glyphs: 3 files (olive), 3 code units (slate), 1 named set (mauve), 1 failure; 6 flow edges, 2 failure paths; 8 markers.
Sidebar: world-map grid (4 lit cells), tree (7 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-az-naming--one-namer-assembles-every-name--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/one-namer-assembles-every-name.md).

## At a glance

A 1572 × 750 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `SOURCES`, `RESOLVER`, `ASSEMBLER` and `CONSUMERS`. It holds eight glyphs (three files, three code units, one
named set and one failure) joined by six flow edges and two failure paths, with eight markers and a legend panel along the bottom. The eye
lands first on the wide code unit in the resolver band, which three edges enter from above.

## Reading path

1. Markers 1, 2 and 3, sources band, left to right: the files azure.yml · customer.yml, template · options.yml and variants.yml.
2. Down the three parallel edges to marker 4, resolver band: the code unit Get-BicepResourceName.
3. Down to marker 6, assembler band: the code unit Get-AzureResourceName, with marker 5, the named set registries, on its left.
4. Right along the red edge to marker 7: the failure throw, which a second red edge also enters from Get-BicepResourceName above.
5. Down to marker 8, consumers band: the code unit Get-BicepResourceGroupName.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                    |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 3     | azure.yml · customer.yml, template · options.yml, variants.yml (sources band, left to right)                                             |
| code unit             | 3     | Get-BicepResourceName (resolver band, wide), Get-AzureResourceName (assembler band, centre), Get-BicepResourceGroupName (consumers band) |
| named set             | 1     | registries (assembler band, left)                                                                                                        |
| failure               | 1     | throw (assembler band, right)                                                                                                            |

Files are olive, code units slate and the named set mauve, all with white names.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                              |
| ------------ | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 6     | each of the three files → Get-BicepResourceName; Get-BicepResourceName → Get-AzureResourceName; registries → Get-AzureResourceName; Get-AzureResourceName → Get-BicepResourceGroupName |
| failure path | 2     | Get-AzureResourceName → throw (horizontal); Get-BicepResourceName → throw (vertical)                                                                                                   |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a label or chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| red rounded box   | failure                    |
| grey arrow        | flow: feeds the next       |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-az-naming--one-namer-assembles-every-name--architecture.grid.md),
[tree](adr-az-naming--one-namer-assembles-every-name--architecture.tree.md) and
[value-chain map](adr-az-naming--one-namer-assembles-every-name--architecture.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-AZ-NAMING); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-AZ-NAMING);
  `automation × .ps1` (7 files: 7 cite ADR-AZ-NAMING); `automation × .yml` (4 files: 4 cite ADR-AZ-NAMING); `docs × .md` (4 files: 3 cite
  ADR-AZ-NAMING; 1 is the ADR file of ADR-AZ-NAMING).
- **Tree** (the repository's files): 7 lit groups, `Az.Templates` (7 files); `Azure` (4 files); `Docs` (2 files); `adr/azure` (2 files);
  `Variants` (1 file); `adr/*` (1 file); `docs` (1 file). The ADR file `docs/adr/azure/azure-naming-standard.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `CLOUD × DEPLOY`, because ADR-AZ-NAMING: its
  ADR domain `azure` sits on the CLOUD row (ADR-DSGN-TRACK#14), and deploy is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
