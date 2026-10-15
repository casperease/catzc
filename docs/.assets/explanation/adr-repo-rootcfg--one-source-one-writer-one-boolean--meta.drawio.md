---
catzc:
  derived:
    path: docs/.assets/explanation/adr-repo-rootcfg--one-source-one-writer-one-boolean--meta.drawio.md
    kind: asset-description
    body_sha: "190a3297513d"
    links:
      - docs/.assets/explanation/adr-repo-rootcfg--one-source-one-writer-one-boolean--meta.drawio.png
      - docs/explanation/repository/one-source-one-writer-one-boolean.md
---

# One source of truth, one writer, one boolean: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands.
Glyphs: 2 files (olive), 1 code unit (slate), 2 results (green); 4 flow edges, 2 with fraction chips; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-rootcfg--one-source-one-writer-one-boolean--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/repository/one-source-one-writer-one-boolean.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands, labelled `SOURCE OF TRUTH`, `MATERIALISE` and `TARGET`. It holds five glyphs, two files, one tall code unit and two results, joined
by four horizontal flow edges, with five markers and a legend panel along the bottom. The eye lands first on the tall slate code unit in the
middle band, which both left-hand files feed and both results leave.

## Reading path

1. Marker 1, left band: the file "source of truth", upper row.
2. Marker 2, left band: the file "registry", lower row.
3. Along the two edges into marker 3, middle band: the tall code unit "single writer".
4. Along the upper edge, fraction chip 19/23, to marker 4, right band: the result "gitignored target".
5. Along the lower edge, fraction chip 4/23, to marker 5, right band: the result "tracked target".

## Glyphs

| Glyph (legend phrase) | Count | Where                                                           |
| --------------------- | ----- | --------------------------------------------------------------- |
| file                  | 2     | source of truth (left band, upper), registry (left band, lower) |
| code unit             | 1     | single writer (middle band, spanning both rows)                 |
| result                | 2     | gitignored target (right band, upper), tracked target (lower)   |

Files are olive, the code unit slate and the results green, all with light names.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                   |
| ------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| flow, feeds the next step | 4     | source of truth → single writer, registry → single writer, single writer → gitignored target (19/23), single writer → tracked target (4/23) |

Every edge is straight and horizontal, and none crosses another. The two edges leaving the code unit carry a fraction chip each.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                 |
| ----------------- | -------------------------------------- |
| olive page        | file                                   |
| slate rounded box | code unit                              |
| green rounded box | result                                 |
| thin arrow        | flow: feeds the next step              |
| bold `7/23`       | fraction chip: entries that land there |
| light disc `1`    | marker: a Walkthrough step             |

## Sidebar

The lens badge reads `META`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, a lit ADR file, and idle.
