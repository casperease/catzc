---
catzc:
  derived:
    path: docs/.assets/explanation/adr-repo-rootcfg--import-materialises-two-gates-name-the-fix--operations.drawio.md
    kind: asset-description
    body_sha: "632b2688cc51"
    adrs: []
---

# The import materialises every root file; two gates catch drift: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 code units (slate), 1 result (green), 2 gates (neutral rhombi), 2 failures (red); 3 flow edges, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-rootcfg--import-materialises-two-gates-name-the-fix--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in
[the article](../../explanation/repository/import-materialises-two-gates-name-the-fix.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `RUN`, `MATERIALISE` and `TARGET`. It holds seven glyphs, two code units, one result, two gates and two failures, joined by
three flow edges and two failure paths, with seven markers and a legend panel along the bottom. The two gates share a thin frame below the
result. The eye lands first on the two red failures at the right edge of the wide right band.

## Reading path

1. Marker 1, left band: the code unit "importer.ps1".
2. Along the edge to marker 2, middle band: the code unit "Build-RootConfig".
3. Along the edge to marker 3, right band, top: the result "root file current".
4. Down the short edge into the frame: marker 4, the gate "Test-GeneratedFiles", whose red failure path leads right to marker 5, the failure
   "stale, regenerate".
5. Below it, marker 6, the gate "Test-RootConfigFiles", whose red failure path leads right to marker 7, the failure "registry and git
   disagree".

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------- |
| code unit             | 2     | importer.ps1 (left band), Build-RootConfig (middle band)                |
| result                | 1     | root file current (right band, top)                                     |
| gate                  | 2     | Test-GeneratedFiles and Test-RootConfigFiles (right band, in one frame) |
| failure               | 2     | stale, regenerate; registry and git disagree (right band, right edge)   |

Code units are slate, the result green, the gates neutral dark rhombi with a thick light rim, and the failures red. The frame is chrome, not
a kind.

## Edges

| Edge kind                 | Count | From → to                                                                                                  |
| ------------------------- | ----- | ---------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 3     | importer.ps1 → Build-RootConfig, Build-RootConfig → root file current, root file current → the gates frame |
| failure path              | 2     | Test-GeneratedFiles → stale, regenerate; Test-RootConfigFiles → registry and git disagree                  |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| neutral rhombus   | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `OPS`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, a lit ADR file, and idle.
