---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.md
    kind: asset-description
    body_sha: "3c396fcf04f0"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Every module file is in exactly one aspect: the diagram described

```text
A 1572 x 622 diagram, read left to right through three column bands.
Glyphs: 1 code unit (slate), 2 named sets (mauve), 2 ADR-only; 4 edges; 5 markers.
Sidebar: world-map grid (4 lit cells), tree (6 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/every-file-in-exactly-one-aspect.md).

## At a glance

A 1572 × 622 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
column bands, labelled FOLDER, FIRST MATCH and LOCKS. It holds five glyphs (one code unit, two named sets and two ADR-only) joined by four
edges in two rows, with five markers and a legend panel along the bottom. The eye lands first on the tall code unit filling FOLDER.

## Reading path

1. Marker 1, FOLDER: the tall code unit Module folder.
2. Right along the top thick edge to marker 2, FIRST MATCH, top: the named set live; then along a dashed edge to marker 4, LOCKS, top: the
   ADR-only glyph live lock.
3. Right along the bottom thick edge to marker 3, FIRST MATCH, bottom: the named set tests; then along a dashed edge to marker 5, LOCKS,
   bottom: the ADR-only glyph tests lock.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                |
| --------------------- | ----- | ---------------------------------------------------- |
| code unit             | 1     | Module folder (FOLDER, full height)                  |
| named set             | 2     | live (FIRST MATCH, top), tests (FIRST MATCH, bottom) |
| ADR-only              | 2     | live lock (LOCKS, top), tests lock (LOCKS, bottom)   |

The code unit is slate and the named sets are mauve, both with white names; the ADR-only glyphs are dashed white boxes.

## Edges

| Edge kind              | Count | From → to                                   |
| ---------------------- | ----- | ------------------------------------------- |
| thick (to a named set) | 2     | Module folder → live, Module folder → tests |
| ADR-only               | 2     | live → live lock, tests → tests lock        |

All four edges are straight and horizontal, pointing right, two per row. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                             |
| ----------------- | ---------------------------------- |
| slate rounded box | code unit                          |
| mauve rounded box | named set                          |
| dashed white box  | ADR-only                           |
| thick arrow       | thick: to a named set, first match |
| dashed arrow      | ADR-only (no code)                 |
| dark disc `1`     | marker: a Walkthrough step         |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md),
[tree](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md) and
[value-chain map](adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-ASPECT); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-DSGN-ASPECT);
  `automation × .ps1` (5 files: 5 cite ADR-DSGN-ASPECT); `automation × .yml` (2 files: 2 cite ADR-DSGN-ASPECT); `docs × .md` (3 files: 2
  cite ADR-DSGN-ASPECT; 1 is the ADR file of ADR-DSGN-ASPECT).
- **Tree** (the repository's files): 6 lit groups, `Globs` (4 files); `Variants` (4 files); `adr/dsgn` (2 files); `Docs` (1 file);
  `QualityGates` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/module-aspects.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × AUTOMA`, because ADR-DSGN-ASPECT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-ASPECT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
