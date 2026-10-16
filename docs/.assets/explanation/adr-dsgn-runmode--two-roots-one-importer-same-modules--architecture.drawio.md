---
catzc:
  immutable:
    with_body_sha: "70aa3884c443"
    path: docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-runmode-two-roots-one-importer-same-modules-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md
      - docs/explanation/design/two-roots-one-importer-same-modules.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two code roots feed one importer, which loads the same modules: the diagram described

```text
A 1572 x 740 diagram, read top to bottom through four bands.
Glyphs: 5 code units (slate), 2 stores (slate), 1 named set (mauve); 4 flow edges, 2 thick edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-RUNMODE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.grid.md),
[tree](tree/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.tree.md) and
[value-chain map](chain/adr-dsgn-runmode--two-roots-one-importer-same-modules--architecture.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
