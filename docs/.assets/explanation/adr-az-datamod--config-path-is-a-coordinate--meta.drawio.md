---
catzc:
  immutable:
    with_body_sha: bb5d153b74ef
    path: docs/.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-datamod-config-path-is-a-coordinate-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png
      - docs/explanation/azure/config-path-is-a-coordinate.md
---

# A config file's path is a coordinate: the diagram described

```text
A 1572 x 660 diagram, read left to right through two bands.
Glyphs: 2 files (olive), 1 gate, 2 environments; 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--config-path-is-a-coordinate--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/azure/config-path-is-a-coordinate.md).

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

The lens badge reads `META`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
