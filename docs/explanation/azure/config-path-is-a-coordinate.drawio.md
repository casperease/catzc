---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/azure/config-path-is-a-coordinate.drawio.md
    folder: docs/explanation/azure
    name: config-path-is-a-coordinate-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png
      - docs/explanation/.assets/chain/adr-az-datamod--config-path-is-a-coordinate--meta.chain.md
      - docs/explanation/.assets/grid/adr-az-datamod--config-path-is-a-coordinate--meta.grid.md
      - docs/explanation/.assets/tree/adr-az-datamod--config-path-is-a-coordinate--meta.tree.md
      - docs/explanation/azure/config-path-is-a-coordinate.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A config file's path is a coordinate that resolves to one subscription and one resource group: the diagram described

```text
A 1572 x 660 diagram, read left to right through two bands.
Glyphs: 2 files (olive), 1 gate, 2 environments; 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](config-path-is-a-coordinate.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, `CONFIGURATION TREE` on the left and the wider `RESOLVED` on the right. It holds five glyphs, two files stacked in the left
band and a gate followed by two environments in a row in the right band, joined by four flow edges, with five markers and a legend panel
along the bottom. The eye lands first on the gate, the rhombus at the start of the right band where the two edges from the files converge.

## Reading path

1. Marker 1, left band, upper file: root config.
2. Marker 2, left band, lower file: customer config.
3. Along the two converging edges to marker 3, right band: the gate, exactly one subscription.
4. Right along the row to marker 4, the environment subscription, and marker 5, the environment resource group.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                       |
| --------------------- | ----- | ----------------------------------------------------------- |
| file                  | 2     | root config and customer config, stacked in the left band   |
| gate                  | 1     | exactly one subscription, at the left of the right band     |
| environment           | 2     | subscription and resource group, in a row in the right band |

Files are olive with a folded corner; the gate and the environments are neutral, dark with a light rim.

## Edges

| Edge kind         | Count | From → to                                                                                      |
| ----------------- | ----- | ---------------------------------------------------------------------------------------------- |
| flow, resolves to | 4     | root config → gate, customer config → gate, gate → subscription, subscription → resource group |

The two edges from the files converge on the gate's left vertex; the two in the right band are horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch          | Phrase                     |
| --------------- | -------------------------- |
| olive page      | file                       |
| neutral rhombus | gate                       |
| neutral hexagon | environment                |
| thin arrow      | flow: resolves to          |
| light disc `1`  | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-datamod--config-path-is-a-coordinate--meta.grid.md),
[tree](../.assets/tree/adr-az-datamod--config-path-is-a-coordinate--meta.tree.md) and
[value-chain map](../.assets/chain/adr-az-datamod--config-path-is-a-coordinate--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-AZ-CUSTOMER and ADR-AZ-DATAMOD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
