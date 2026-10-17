---
catzc:
  immutable:
    with_body_sha: "0cc818363bcc"
    repo_status: clean
    path: docs/explanation/flow/independence-check-groups-by-layer.drawio.md
    folder: docs/explanation/flow
    name: independence-check-groups-by-layer-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md
      - docs/explanation/flow/independence-check-groups-by-layer.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Test-GlobSetIndependence groups by layer: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands, the checks on the right.
Glyphs: 4 named sets (mauve), 2 gates (grey), 1 code unit (slate), 1 failure (red).
Edges: 4 flow, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](independence-check-groups-by-layer.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. Named sets sit on the left of each band; a column of two gates and one
code unit on the right joins them, with a failure to its right. It holds four named sets, two gates, one code unit and one failure, joined
by four flow edges and one failure path, with eight markers and a legend panel. The eye lands first on the red failure in the middle band.

## Reading path

1. Markers 1 to 4, down the left: deployable-unit sets (top band), declared loose-filesets and ReservedNames umbrellas (middle band),
   module-layer sets (bottom band).
2. Marker 5, on the right vertex of the gate Overlaps per pair in the top band, fed from deployable-unit sets.
3. Marker 6, on the right vertex of the gate Overlaps per pair in the bottom band, fed from module-layer sets.
4. Marker 7, the code unit Write-QualityGateReport in the middle band, which both gates feed.
5. Marker 8, the failure One throw lists every pair, at the end of the red failure path.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | deployable-unit sets (top), declared loose-filesets and ReservedNames umbrellas (middle), module-layer sets (bottom) |
| gate                  | 2     | Overlaps per pair (top band, right; bottom band, right)                                                              |
| code unit             | 1     | Write-QualityGateReport (middle band, between the gates)                                                             |
| failure               | 1     | One throw lists every pair (middle band, far right)                                                                  |

Named sets are mauve and the code unit slate, both with white names; the gates are grey rhombuses with a 3 px rim; the failure is light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                                         |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | deployable-unit sets → the gate in the top band, module-layer sets → the gate in the bottom band, each of the two gates → Write-QualityGateReport |
| failure path | 1     | Write-QualityGateReport → One throw lists every pair                                                                                              |

Every edge is straight; none crosses another. The two named sets in the middle band have no edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| mauve rounded box | named set                  |
| slate rounded box | code unit                  |
| grey rhombus      | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow, in code order        |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--independence-check-groups-by-layer--implementation.chain.md), which hold the reason
for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
