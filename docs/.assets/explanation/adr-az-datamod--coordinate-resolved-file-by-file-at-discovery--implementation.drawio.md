---
catzc:
  immutable:
    with_body_sha: ccd45c8651f3
    path: docs/.assets/explanation/adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-az-datamod-coordinate-resolved-file-by-file-at-discovery-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    links:
      - docs/.assets/explanation/adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation.drawio.png
      - docs/explanation/azure/coordinate-resolved-file-by-file-at-discovery.md
---

# The coordinate is resolved file by file at discovery: the diagram described

```text
A 1572 x 720 diagram, read left to right along the top band, then up from the two bands below it.
Glyphs: 3 files (olive), 5 code units (slate), 1 gate, 1 failure; 8 flow edges, 2 failure paths; 9 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--coordinate-resolved-file-by-file-at-discovery--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/azure/coordinate-resolved-file-by-file-at-discovery.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along the
full-width top band, `DISCOVERY`, through a file, two code units, a gate and a final code unit, with a failure glyph beneath the band's
middle. Two shorter full-width bands below it, `RESOLVER` and `IDENTITY`, hold two code units and two files whose edges point up into the
gate. Ten glyphs in all, joined by eight flow edges and two failure paths, with nine markers and a legend panel along the bottom. The eye
lands first on the red failure glyph under the top band.

## Reading path

1. Marker 1, top band, far left: the file configuration/apex/nsub.yml.
2. Right along the row: marker 2, the code unit Get-BicepTemplates; marker 3, the code unit Resolve-BicepConfigName.
3. Down to marker 4, bottom band: the file azure.yml, whose edge rises to marker 5, middle band: the code unit Get-BicepConfig…Candidates.
   To its right, marker 6: the code unit Get-AzureCustomer, fed from the file customer.yml below it.
4. Up the vertical edge to marker 7, top band: the gate Get-Bicep…ConfigViolations.
5. Marker 8, under the top band's middle: the failure glyph has an invalid config, with red edges from Resolve-BicepConfigName and from the
   gate's lower-left side.
6. Marker 9, top band, far right: the code unit BicepSlot.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| file                  | 3     | configuration/apex/nsub.yml (top band, left); azure.yml and customer.yml (bottom band)                                         |
| code unit             | 5     | Get-BicepTemplates, Resolve-BicepConfigName, BicepSlot (top band); Get-BicepConfig…Candidates, Get-AzureCustomer (middle band) |
| gate                  | 1     | Get-Bicep…ConfigViolations, top band, right of centre                                                                          |
| failure               | 1     | has an invalid config, below the top band's middle                                                                             |

Files are olive, code units slate, both with white names; the gate is neutral with a thick light rim; the failure is the only red. Two names
are elided in the middle with `…`; the article gives them in full.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                          |
| ------------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 8     | config file → Get-BicepTemplates → Resolve-BicepConfigName → gate → BicepSlot (4); azure.yml → candidates, customer.yml → Get-AzureCustomer, Get-AzureCustomer → candidates, candidates → gate (4) |
| failure path              | 2     | Resolve-BicepConfigName → has an invalid config (vertical), gate → has an invalid config (from the rhombus's lower-left side)                                                                      |

The top row is horizontal; the three edges from the lower bands are vertical, and one points left. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| neutral rhombus   | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `IMPL`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
