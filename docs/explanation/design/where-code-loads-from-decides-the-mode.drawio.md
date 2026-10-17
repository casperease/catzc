---
catzc:
  immutable:
    with_body_sha: "76086db80ddf"
    repo_status: clean
    path: docs/explanation/design/where-code-loads-from-decides-the-mode.drawio.md
    folder: docs/explanation/design
    name: where-code-loads-from-decides-the-mode-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md
      - docs/explanation/design/where-code-loads-from-decides-the-mode.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Where the code loads from decides the run mode: the diagram described

```text
A 1572 x 630 diagram, read top to bottom through four bands.
Glyphs: 2 stores (slate), 1 code unit (slate), 1 named set (mauve); 2 flow edges, 1 thick edge; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](where-code-loads-from-decides-the-mode.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-RUNMODE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-runmode--where-code-loads-from-decides-the-mode--meta.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-RUNMODE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
