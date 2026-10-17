---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/design/every-file-in-exactly-one-aspect.drawio.md
    folder: docs/explanation/design
    name: every-file-in-exactly-one-aspect-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.png
      - docs/explanation/.assets/chain/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md
      - docs/explanation/.assets/grid/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md
      - docs/explanation/.assets/tree/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md
      - docs/explanation/design/every-file-in-exactly-one-aspect.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every module file is in exactly one aspect: the diagram described

```text
A 1572 x 622 diagram, read left to right through three column bands.
Glyphs: 1 code unit (slate), 2 named sets (mauve), 2 ADR-only; 4 edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](every-file-in-exactly-one-aspect.md).

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

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-ASPECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-aspect--every-file-in-exactly-one-aspect--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
