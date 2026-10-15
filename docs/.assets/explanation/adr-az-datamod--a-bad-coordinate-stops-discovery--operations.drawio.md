# docs/.assets/explanation/adr-az-datamod--a-bad-coordinate-stops-discovery--operations.drawio.md

`A bad coordinate stops discovery: the diagram described`

```text
A 1572 x 660 diagram, read left to right through two bands.
Glyphs: 1 file (olive), 2 code units (slate), 1 result, 3 failures in a frame; 3 flow edges, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-az-datamod--a-bad-coordinate-stops-discovery--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/azure/a-bad-coordinate-stops-discovery.md).

## At a glance

A 1572 × 660 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, `RUN` on the left and the wider `SEE` on the right. The left band holds a file and two code units stacked to its right; the
right band holds a green result at the top and three red failures stacked inside a thin frame below it. Seven glyphs, joined by three flow
edges and two failure paths, with seven markers and a legend panel along the bottom. The eye lands first on the three red failures, the
largest block of colour.

## Reading path

1. Marker 1, left band, far left: the file configuration/apex/nsub.yml.
2. Along the two diverging edges to markers 2 and 3, left band, stacked: the code units Get-BicepTemplates above and Assert-BicepTemplate
   below.
3. Right along the top edge to marker 4, right band: the result apex/nsub -> apex_nonprod.
4. Along the two red edges into the frame: markers 5, 6 and 7, right band, stacked: the failures cannot be resolved, more than one
   subscription and is not a customer key.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                     |
| --------------------- | ----- | ----------------------------------------------------------------------------------------- |
| file                  | 1     | configuration/apex/nsub.yml, left band, far left                                          |
| code unit             | 2     | Get-BicepTemplates and Assert-BicepTemplate, left band, stacked                           |
| result                | 1     | apex/nsub -> apex_nonprod, right band, top                                                |
| failure               | 3     | cannot be resolved, more than one subscription, is not a customer key, right band, framed |

The file is olive and the code units slate, both with white names; the result is green and the failures are the only red. The frame around
the failures is chrome, a thin dark rim with no fill, and has no legend row.

## Edges

| Edge kind                 | Count | From → to                                                                                         |
| ------------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 3     | config file → Get-BicepTemplates, config file → Assert-BicepTemplate, Get-BicepTemplates → result |
| failure path              | 2     | Get-BicepTemplates → the frame, Assert-BicepTemplate → the frame                                  |

The two edges from the file diverge gently; the edge into the result is horizontal; the two red edges end on the frame's left edge. None
crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below it
names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
