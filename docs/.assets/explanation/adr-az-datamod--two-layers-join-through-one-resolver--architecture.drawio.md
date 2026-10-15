---
catzc:
  derived:
    path: docs/.assets/explanation/adr-az-datamod--two-layers-join-through-one-resolver--architecture.drawio.md
    kind: asset-description
    body_sha: "624f9d0de2d1"
    links:
      - docs/.assets/explanation/adr-az-datamod--two-layers-join-through-one-resolver--architecture.drawio.png
      - docs/explanation/azure/two-layers-join-through-one-resolver.md
---

# Two layers join through one resolver: the diagram described

```text
A 1572 x 660 diagram, read left to right through two bands.
Glyphs: 3 files (olive), 3 code units (slate), 1 gate; 7 flow edges; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--two-layers-join-through-one-resolver--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/azure/two-layers-join-through-one-resolver.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, the wide `TEMPLATING LAYER` and the narrow `IDENTITY LAYER` at the right edge. It holds seven glyphs: a file at the far left,
two code units stacked to its right, a gate in the middle, a code unit after it, and two files stacked in the right band. Seven flow edges
join them, with seven markers and a legend panel along the bottom. The eye lands first on the gate, the only rhombus, in the centre of the
drawing.

## Reading path

1. Marker 1, left band, far left: the file configuration/ tree.
2. Markers 2 and 3, left band, stacked: the code units Get-BicepTemplates above and Assert-BicepTemplate below, each with an edge back to
   the file and an edge forward to the gate.
3. Marker 4, centre: the gate Get-Bicep…ConfigViolations.
4. Marker 5, right of the gate: the code unit Get-BicepConfig…Candidates.
5. Markers 6 and 7, right band, stacked: the files azure.yml above and customer.yml below.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                        |
| --------------------- | ----- | -------------------------------------------------------------------------------------------- |
| file                  | 3     | configuration/ tree (left band, far left); azure.yml and customer.yml (right band, stacked)  |
| code unit             | 3     | Get-BicepTemplates and Assert-BicepTemplate (left band, stacked); Get-BicepConfig…Candidates |
| gate                  | 1     | Get-Bicep…ConfigViolations, centre of the left band                                          |

Files are olive, code units slate, both with white names; the gate is neutral with a thick light rim. Two names are elided in the middle
with `…`; the article gives them in full.

## Edges

| Edge kind        | Count | From → to                                                                                                                                                                            |
| ---------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow, depends on | 7     | Get-BicepTemplates → tree, Assert-BicepTemplate → tree, Get-BicepTemplates → gate, Assert-BicepTemplate → gate, gate → candidates, candidates → azure.yml, candidates → customer.yml |

The two edges into the tree point left; every other edge points right or slopes gently right. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| thin arrow        | flow: depends on           |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `ARCH`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
