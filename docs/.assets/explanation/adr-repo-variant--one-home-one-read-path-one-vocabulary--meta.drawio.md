---
catzc:
  derived:
    path: docs/.assets/explanation/adr-repo-variant--one-home-one-read-path-one-vocabulary--meta.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: d07547ca561f
    links:
      - docs/.assets/explanation/adr-repo-variant--one-home-one-read-path-one-vocabulary--meta.drawio.png
      - docs/explanation/repository/one-home-one-read-path-one-vocabulary.md
---

# A repo-wide switch has one home, one read path and one guard vocabulary: the diagram described

```text
A 1572 x 648 diagram, read top to bottom through four bands.
Glyphs: 1 file (olive), 2 code units (slate), 1 named set (mauve); 3 downward edges; 4 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-repo-variant--one-home-one-read-path-one-vocabulary--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/repository/one-home-one-read-path-one-vocabulary.md).

## At a glance

A 1572 × 648 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `VARIANT`, `READER`, `PRIMITIVES` and `CALLERS`. It holds four glyphs in one centred column, a file, two code
units and a named set, joined by three downward edges, with four markers and a legend panel along the bottom. The eye lands first on the
olive file at the top of the column.

## Reading path

1. Marker 1, top band: the file `one home`, centred.
2. Down one edge to marker 2, second band: the code unit `one read path`.
3. Down one edge to marker 3, third band: the code unit `one guard vocabulary`.
4. Down the thick edge to marker 4, bottom band: the named set `any module above Config`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                              |
| --------------------- | ----- | ------------------------------------------------------------------ |
| file                  | 1     | `one home` (top band)                                              |
| code unit             | 2     | `one read path` (second band), `one guard vocabulary` (third band) |
| named set             | 1     | `any module above Config` (bottom band)                            |

The file is olive, the code units slate and the named set mauve, all with light names.

## Edges

| Edge kind             | Count | From → to                                                      |
| --------------------- | ----- | -------------------------------------------------------------- |
| flow: feeds           | 2     | one home → one read path, one read path → one guard vocabulary |
| thick, to a named set | 1     | one guard vocabulary → any module above Config                 |

Every edge is straight and vertical, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns over two rows, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| thin arrow        | flow: feeds                |
| thick arrow       | to a named set             |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The lens badge reads `META`. The three minimaps, the world-map grid, the tree and the value-chain map, sit above it, and the map key below
it names the four swatches: lit, lit by passing mentions only, lit ADR file, and idle.
