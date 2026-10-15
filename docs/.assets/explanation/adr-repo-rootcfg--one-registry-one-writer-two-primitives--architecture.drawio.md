---
catzc:
  derived:
    path: docs/.assets/explanation/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.md
    kind: asset-description
    body_sha: "085640e8bc5c"
    adrs: []
    links:
      - docs/.assets/explanation/adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.png
      - docs/explanation/repository/one-registry-one-writer-two-primitives.md
---

# One registry, one writer, two write primitives: the diagram described

```text
A 1572 x 640 diagram, read left to right through four bands under one span bar.
Glyphs: 2 files (olive), 1 named set (mauve), 3 code units (slate), 2 results (green); 7 flow edges, 2 with fraction chips; 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-rootcfg--one-registry-one-writer-two-primitives--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/repository/one-registry-one-writer-two-primitives.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands, labelled `SOURCE OF TRUTH`, `CATZC.BASE.ROOTCONFIG`, `CATZC.BASE.FILES` and `TARGET`; a span bar labelled `IMPORTER TAIL` runs over
the two middle bands. It holds eight glyphs, two files, one named set, three code units and two results, joined by seven horizontal flow
edges, with eight markers and a legend panel along the bottom. The two results share a thin frame in the right band. The eye lands first on
the tall slate code unit that fills the second band.

## Reading path

1. Markers 1, 2 and 3, left band, top to bottom: the file "authored source files", the named set "generator functions", the file
   "rootconfig.yml".
2. Along the three edges into marker 4, second band: the tall code unit "Build-RootConfig".
3. Along the upper edge, fraction chip 7/23, to marker 5, third band: the code unit "Set-FileLink"; along the lower edge, fraction chip
   16/23, to marker 6: the code unit "Write-FileIfChanged".
4. Marker 7, right band, upper: the result "gitignored targets", entered from Set-FileLink.
5. Marker 8, right band, lower: the result "tracked targets"; the edge from Write-FileIfChanged ends on the frame that holds both results.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| file                  | 2     | authored source files (left band, top), rootconfig.yml (left band, bottom)              |
| named set             | 1     | generator functions (left band, middle)                                                 |
| code unit             | 3     | Build-RootConfig (second band, tall), Set-FileLink and Write-FileIfChanged (third band) |
| result                | 2     | gitignored targets and tracked targets (right band, inside one frame)                   |

Files are olive, the named set mauve, code units slate and results green, all with light names. The frame is chrome, not a kind.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                                               |
| ------------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 7     | authored source files → Build-RootConfig, generator functions → Build-RootConfig, rootconfig.yml → Build-RootConfig, Build-RootConfig → Set-FileLink (7/23), Build-RootConfig → Write-FileIfChanged (16/23), Set-FileLink → gitignored targets, Write-FileIfChanged → the targets frame |

Every edge is straight and horizontal, and none crosses another. The two edges leaving Build-RootConfig carry a fraction chip each.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                  |
| ----------------- | --------------------------------------- |
| olive page        | file                                    |
| mauve rounded box | named set                               |
| slate rounded box | code unit                               |
| green rounded box | result                                  |
| thin arrow        | flow: feeds the next step               |
| bold `7/23`       | fraction chip: entries taking this edge |
| light disc `1`    | marker: a Walkthrough step              |

## Sidebar

The lens badge reads `ARCH`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, a lit ADR file, and idle.
