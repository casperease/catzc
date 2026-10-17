---
catzc:
  immutable:
    with_body_sha: f7d4635c118e
    repo_status: clean
    path: docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-naming-one-namer-assembles-every-name-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.png
      - docs/.assets/explanation/chain/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md
      - docs/.assets/explanation/grid/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md
      - docs/.assets/explanation/tree/adr-az-naming--one-namer-assembles-every-name--architecture.tree.md
      - docs/explanation/azure/one-namer-assembles-every-name.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One namer assembles every Azure name: the diagram described

```text
A 1572 x 750 diagram, read top to bottom through four bands.
Glyphs: 3 files (olive), 3 code units (slate), 1 named set (mauve), 1 failure; 6 flow edges, 2 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-naming--one-namer-assembles-every-name--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](one-namer-assembles-every-name.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-naming--one-namer-assembles-every-name--architecture.grid.md),
[tree](../.assets/tree/adr-az-naming--one-namer-assembles-every-name--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-az-naming--one-namer-assembles-every-name--architecture.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
