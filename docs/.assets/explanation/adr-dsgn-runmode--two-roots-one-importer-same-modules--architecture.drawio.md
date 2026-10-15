---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
    kind: asset-description
    body_sha: ce5fed6b2bec
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Two code roots feed one importer, which loads the same modules: the diagram described

```text
A 1572 x 740 diagram, read top to bottom through four bands.
Glyphs: 5 code units (slate), 2 stores (slate), 1 named set (mauve); 4 flow edges, 2 thick edges; 8 markers.
Sidebar: world-map grid (5 lit cells), tree (13 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/design/two-roots-one-importer-same-modules.md).

## At a glance

A 1572 × 740 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom. Two bands sit
side by side at the top, SOURCE (narrow, left) and BUILD (wide, right); below them run two full-width bands, ONE IMPORTER and SAME MODULES.
It holds eight glyphs, five code units, two stores and one named set, joined by six edges, with eight markers and a legend panel along the
bottom. The eye lands first on the full-width code unit in the ONE IMPORTER band, which both stores point down into.

## Reading path

1. Marker 1, SOURCE band: the code unit importer.ps1, with an edge down to marker 2, the store `<RepositoryRoot>/automation`.
2. Marker 3, BUILD band, right: the code unit Import-Catzc.ps1, with an edge down to marker 5, the store `Catzc/<v>`.
3. Marker 4, BUILD band, centre: the code unit Catzc.Base.Exporter, between the two stores, with no edge.
4. Down the two edges from the stores to marker 6, the code unit Catzc.Internal.
5. Down the thick edge to marker 7, the named set Catzc.\* modules, which marker 8, the code unit Catzc.Base.Repository, points into from
   the right along a second thick edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                           |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | importer.ps1 (SOURCE), Import-Catzc.ps1 and Catzc.Base.Exporter (BUILD), Catzc.Internal (ONE IMPORTER, full width), Catzc.Base.Repository (SAME MODULES, right) |
| store                 | 2     | `<RepositoryRoot>/automation` (SOURCE), `Catzc/<v>` (BUILD, right)                                                                                              |
| named set             | 1     | Catzc.\* modules (SAME MODULES, left)                                                                                                                           |

Code units and stores are slate and the named set is mauve, all with white names. Catzc.Base.Exporter is the one glyph with no edge.

## Edges

| Edge kind             | Count | From → to                                                                                                                |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| flow                  | 4     | importer.ps1 → source store; Import-Catzc.ps1 → build store; source store → Catzc.Internal; build store → Catzc.Internal |
| thick, to a named set | 2     | Catzc.Internal → Catzc.\* modules; Catzc.Base.Repository → Catzc.\* modules                                              |

Every edge is straight, vertical or horizontal, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                        |
| ----------------- | --------------------------------------------- |
| slate rounded box | code unit                                     |
| slate cylinder    | store: a code root                            |
| mauve rounded box | named set                                     |
| thin arrow        | flow: hands on the code root                  |
| thick arrow       | thick: hands on the code root, to a named set |
| dark disc `1`     | marker: a Walkthrough step                    |
| grey band         | band: a mode or a stage                       |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md),
[tree](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md) and
[value-chain map](adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .ps1` (28 files: 28 cite ADR-DSGN-RUNMODE);
  `automation × .yml` (2 files: 2 cite ADR-DSGN-RUNMODE); `docs × .md` (3 files: 2 cite ADR-DSGN-RUNMODE; 1 is the ADR file of
  ADR-DSGN-RUNMODE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are
  mapped through files.yml to ADR-DSGN-RUNMODE).
- **Tree** (the repository's files): 13 lit groups, `ModuleSystem` (8 files); `QualityGates` (5 files); `TypesSystem` (5 files);
  `Root files` (3 files); `Repository` (3 files); `.internal` (2 files); `Docs` (2 files); `Vendor` (2 files); `adr/dsgn` (2 files);
  `ConfigExtensions` (1 file); `Globs` (1 file); `RootConfig` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/run-modes.md`
  carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × AUTOMA`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
