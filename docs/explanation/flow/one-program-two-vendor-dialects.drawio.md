---
catzc:
  immutable:
    with_body_sha: "697272e1f91d"
    repo_status: clean
    path: docs/.assets/explanation/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-globs-one-program-two-vendor-dialects-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.drawio.png
      - docs/.assets/explanation/chain/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.chain.md
      - docs/.assets/explanation/grid/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.grid.md
      - docs/.assets/explanation/tree/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.tree.md
      - docs/explanation/flow/one-program-two-vendor-dialects.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One flattened scan program, two vendor dialects: the diagram described

```text
A 1572 x 650 diagram, read top to bottom through two bands.
Glyphs: 2 named sets (mauve), 3 results (green); 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](one-program-two-vendor-dialects.md).

## At a glance

A 1572 × 650 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through two
full-width bands, labelled `COMPOSE` and `PROJECTION`. It holds five glyphs, two named sets and three results, joined by four flow edges,
with five markers and a legend panel along the bottom. The eye lands first on the wide result in the top band, which spans the right half of
the drawing area.

## Reading path

1. Marker 1, top band, left: the named set base unit.
2. Right along the edge to marker 2: the named set configured unit.
3. Right again to marker 3: the wide result flattened scan program.
4. Down the two edges that leave its underside into the bottom band.
5. Markers 4 and 5, bottom band, left to right: the results GitHub paths and ADO include and exclude.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                  |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------ |
| named set             | 2     | base unit and configured unit (top band, left and centre)                                              |
| result                | 3     | flattened scan program (top band, right, wide); GitHub paths and ADO include and exclude (bottom band) |

Named sets are mauve and results green, both with light names.

## Edges

| Edge kind   | Count | From → to                                                                                                                                                      |
| ----------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds | 4     | base unit → configured unit, configured unit → flattened scan program, flattened scan program → GitHub paths, flattened scan program → ADO include and exclude |

The two edges in the top band are horizontal; the two that cross into the bottom band are vertical and leave the wide result at the centre
of each target. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in two columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| green rounded box | result                     |
| thin arrow        | flow: feeds                |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--one-program-two-vendor-dialects--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
