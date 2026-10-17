---
catzc:
  immutable:
    with_body_sha: a8a8c8b58908
    repo_status: clean
    path: docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-track-units-not-tracks-own-the-pipelines-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.png
      - docs/.assets/explanation/chain/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md
      - docs/.assets/explanation/grid/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md
      - docs/.assets/explanation/tree/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md
      - docs/explanation/design/units-not-tracks-own-the-pipelines.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# CD binds through units, CI binds track sets: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 named sets (mauve), 3 runners (slate); 6 edges; 6 markers; 1 count chip.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](units-not-tracks-own-the-pipelines.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds seven glyphs (four named sets and three runners) joined by six
edges, with six markers, one count chip and a legend panel along the bottom. The eye lands first on the tall named set in the TRACKS band.

## Reading path

1. Marker 1, TRACKS band, top: the named set automation.
2. Marker 2, beside the dashed edge that rises from infrastructure to automation.
3. Marker 3, just below the long edge from automation across to the runner ci-automation; the parallel edge below runs from infrastructure
   to ci-infrastructure.
4. Markers 4 and 5, DEPLOYABLE-UNITS band, bottom row: the named sets foundation base unit and nova · apex · flux · shared, joined by a
   thick edge, with a thick edge entering the first from infrastructure.
5. Marker 6, PIPELINES band, bottom: the runner cd-&lt;unit&gt;, with the count chip 4 on its top-right corner.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | automation, infrastructure (TRACKS band, the second tall); foundation base unit, nova · apex · flux · shared (DEPLOYABLE-UNITS, bottom) |
| runner                | 3     | ci-automation, ci-infrastructure, cd-&lt;unit&gt; (PIPELINES band, one per row)                                                         |

Named sets are mauve and runners slate, both with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| flow      | 3     | automation → ci-automation (marker 3), infrastructure → ci-infrastructure, nova · apex · flux · shared → cd-&lt;unit&gt; |
| thick     | 2     | infrastructure → foundation base unit, foundation base unit → nova · apex · flux · shared                                |
| ADR-only  | 1     | infrastructure → automation (vertical, dashed, marker 2)                                                                 |

Every edge is straight; five are horizontal and one is vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                               |
| ------------------------- | ------------------------------------ |
| mauve rounded box         | named set                            |
| slate pill                | runner                               |
| thin arrow                | flow: binds a pipeline (pipeline:)   |
| thick arrow               | thick: composes into, to a named set |
| dashed arrow              | ADR-only: rests on (no gate)         |
| white pill `4`, slate rim | count chip: pipelines it stands for  |
| dark disc `1`             | marker: a Walkthrough step           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-TRACK): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md),
[tree](../.assets/tree/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
