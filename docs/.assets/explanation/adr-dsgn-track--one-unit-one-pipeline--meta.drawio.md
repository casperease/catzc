---
catzc:
  immutable:
    with_body_sha: f35c0f2ed44a
    path: docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-track-one-unit-one-pipeline-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
      - docs/explanation/design/one-unit-one-pipeline.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One unit, one pipeline; tracks ship through units: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 2 named sets (mauve), 1 runner (slate); 1 thick edge, 1 flow edge; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png) draws, in the vocabulary of the diagram glyphs;
what it means is in [the article](../../explanation/design/one-unit-one-pipeline.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds three glyphs (two named sets and one runner) in one row,
joined by two edges, with five markers and a legend panel below. The drawing area ends at about 390 px; the sidebar runs to the canvas foot.
The eye lands first on the left named set.

## Reading path

1. Marker 1, TRACKS band: the named set Track.
2. Marker 2, beside the thick edge right to the next band.
3. Marker 3, DEPLOYABLE-UNITS band: the named set Deployable-unit.
4. Marker 4, beside the thin edge right to the last band.
5. Marker 5, PIPELINES band: the runner Pipeline.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                        |
| --------------------- | ----- | ------------------------------------------------------------ |
| named set             | 2     | Track (TRACKS band), Deployable-unit (DEPLOYABLE-UNITS band) |
| runner                | 1     | Pipeline (PIPELINES band)                                    |

Named sets are mauve and the runner is slate, both with white names.

## Edges

| Edge kind | Count | From → to                             |
| --------- | ----- | ------------------------------------- |
| thick     | 1     | Track → Deployable-unit (marker 2)    |
| flow      | 1     | Deployable-unit → Pipeline (marker 4) |

Both edges are straight and horizontal, on one line; each edge marker sits just below its line, its rim touching it.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| mauve rounded box | named set                            |
| slate pill        | runner                               |
| thick arrow       | thick: composes into, to a named set |
| thin arrow        | flow: binds one pipeline (1-1)       |
| dark disc `1`     | marker: a Walkthrough step           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-TRACK): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-dsgn-track--one-unit-one-pipeline--meta.grid.md),
[tree](adr-dsgn-track--one-unit-one-pipeline--meta.tree.md) and [value-chain map](adr-dsgn-track--one-unit-one-pipeline--meta.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
