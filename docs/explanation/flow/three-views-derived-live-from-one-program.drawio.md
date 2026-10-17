---
catzc:
  immutable:
    with_body_sha: "4cd115ae091b"
    repo_status: clean
    path: docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-globs-three-views-derived-live-from-one-program-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.png
      - docs/.assets/explanation/chain/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
      - docs/.assets/explanation/grid/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
      - docs/.assets/explanation/tree/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
      - docs/explanation/flow/three-views-derived-live-from-one-program.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One program, three views derived live: the diagram described

```text
A 1572 x 560 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 4 code units (slate); 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](three-views-derived-live-from-one-program.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled `SOURCE`, `FLATTEN` and `DERIVED LIVE`; the last is the widest. It holds five glyphs, one file and four code
units, joined by four straight horizontal edges, with five markers and a legend panel along the bottom. The eye lands first on the tall code
unit in the FLATTEN band.

## Reading path

1. Marker 1, SOURCE band, middle row: the file Registry.
2. Along its edge to marker 2, FLATTEN band: the tall code unit Ordered program.
3. Along three parallel edges to markers 3, 4 and 5, DERIVED LIVE band, top to bottom: the wide code units Trigger, Change report and
   Protection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                         |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | Registry (SOURCE band, middle row)                                                                            |
| code unit             | 4     | Ordered program (FLATTEN band, all rows); Trigger, Change report, Protection (DERIVED LIVE band, one per row) |

The file is olive and the code units are slate, all with white names.

## Edges

| Edge kind | Count | From → to                                                                       |
| --------- | ----- | ------------------------------------------------------------------------------- |
| flow      | 4     | Registry → Ordered program; Ordered program → each of the three wide code units |

Every edge is straight and horizontal; none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive folded page | file                       |
| slate rounded box | code unit                  |
| thin arrow        | flow: derives the next     |
| grey band         | band: one stage            |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
