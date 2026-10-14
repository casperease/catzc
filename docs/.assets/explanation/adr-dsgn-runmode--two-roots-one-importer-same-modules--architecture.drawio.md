# docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md

`Two code roots feed one importer, which loads the same modules: the diagram described`

```text
A 1572 x 740 diagram, read top to bottom through four bands.
Glyphs: 5 code units (slate), 2 stores (slate), 1 named set (mauve); 4 flow edges, 2 thick edges; 8 markers.
Sidebar: axis minimap (main cell DSGN x LOAD), tree minimap, lens badge ARCH, map key.
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

- **Axis minimap:** the main cell is DSGN × LOAD, framed and filled in the LOAD blue with the you-are-here dot. Two touched cells, AUTO ×
  LOAD and AUTO × BUILD, carry a small grey dot. The DSGN and LOAD axis labels carry a blue tick.
- **Tree minimap:** lit tiles labelled .internal, Exporter, adr/dsgn and (root). The adr/dsgn file is framed in dark ink as an ADR file.
- **Lens badge:** ARCH, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
