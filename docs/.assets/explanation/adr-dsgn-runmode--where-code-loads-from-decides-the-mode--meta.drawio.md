---
catzc:
  immutable:
    with_body_sha: "100609dc5ef6"
    path: docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-runmode-where-code-loads-from-decides-the-mode-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
      - docs/explanation/design/where-code-loads-from-decides-the-mode.md
---

# Where the code loads from decides the run mode: the diagram described

```text
A 1572 x 630 diagram, read top to bottom through four bands.
Glyphs: 2 stores (slate), 1 code unit (slate), 1 named set (mauve); 2 flow edges, 1 thick edge; 5 markers.
Sidebar: world-map grid (5 lit cells), tree (13 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/where-code-loads-from-decides-the-mode.md).

## At a glance

A 1572 × 630 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. Two bands sit
side by side at the top, SOURCE (narrow, left) and BUILD (wide, right); below them run two full-width bands, ONE IMPORTER and SAME MODULES.
It holds four glyphs, two stores, one code unit and one named set, joined by three edges, with five markers and a legend panel along the
bottom. The eye lands first on the full-width code unit in the ONE IMPORTER band, which both stores point down into.

## Reading path

1. Marker 1, SOURCE band: the store "the repository".
2. Marker 2, BUILD band: the wide store "a built package".
3. Down the two edges to marker 3, the code unit "one importer".
4. Marker 5, touching the thick edge that leaves the code unit, and down to marker 4, the named set "same modules".

## Glyphs

| Glyph (legend phrase) | Count | Where                                            |
| --------------------- | ----- | ------------------------------------------------ |
| store                 | 2     | the repository (SOURCE), a built package (BUILD) |
| code unit             | 1     | one importer (ONE IMPORTER, full width)          |
| named set             | 1     | same modules (SAME MODULES, centred)             |

Stores and the code unit are slate and the named set is mauve, all with white names.

## Edges

| Edge kind             | Count | From → to                                                     |
| --------------------- | ----- | ------------------------------------------------------------- |
| flow                  | 2     | the repository → one importer; a built package → one importer |
| thick, to a named set | 1     | one importer → same modules (marker 5)                        |

Every edge is straight and vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                     |
| ----------------- | ------------------------------------------ |
| slate cylinder    | store: a code root                         |
| slate rounded box | code unit                                  |
| mauve rounded box | named set                                  |
| thin arrow        | flow: the code loads into                  |
| thick arrow       | thick: the code loads into, to a named set |
| dark disc `1`     | marker: a Walkthrough step                 |
| grey band         | band: a mode or a stage                    |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md),
[tree](adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md) and
[value-chain map](adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .ps1` (28 files: 28 cite ADR-DSGN-RUNMODE);
  `automation × .yml` (2 files: 2 cite ADR-DSGN-RUNMODE); `docs × .md` (3 files: 2 cite ADR-DSGN-RUNMODE; 1 is the ADR file of
  ADR-DSGN-RUNMODE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are
  mapped through files.yml to ADR-DSGN-RUNMODE).
- **Tree** (the repository's files): 13 lit groups, `ModuleSystem` (8 files); `QualityGates` (5 files); `TypesSystem` (5 files);
  `Root files` (3 files); `Repository` (3 files); `.internal` (2 files); `Docs` (2 files); `Vendor` (2 files); `adr/dsgn` (2 files);
  `ConfigExtensions` (1 file); `Globs` (1 file); `RootConfig` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/run-modes.md`
  carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
