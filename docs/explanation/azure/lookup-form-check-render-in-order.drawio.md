---
catzc:
  immutable:
    with_body_sha: "9ce0f7f8a946"
    repo_status: clean
    path: docs/explanation/azure/lookup-form-check-render-in-order.drawio.md
    folder: docs/explanation/azure
    name: lookup-form-check-render-in-order-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.png
      - docs/explanation/.assets/chain/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md
      - docs/explanation/.assets/grid/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md
      - docs/explanation/.assets/tree/adr-az-naming--lookup-form-check-render-in-order--implementation.tree.md
      - docs/explanation/azure/lookup-form-check-render-in-order.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The namer looks up, forms, checks and renders in order: the diagram described

```text
A 1572 x 820 diagram, read top to bottom down one column.
Glyphs: 6 code units (slate), 1 gate, 1 result, 2 failures; 7 flow edges, 5 failure paths; 10 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-naming--lookup-form-check-render-in-order--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](lookup-form-check-render-in-order.md).

## At a glance

A 1572 × 820 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one column
of glyphs: two code units, then a band labelled GUARDED holding four more code units, then a gate and a result. Two failures stand to the
right: a tall one beside the band and a short one beside the gate. Seven flow edges run down the column and five failure paths run across to
the right. Ten markers and a legend panel complete the drawing. The eye lands first on the tall red failure beside the band.

## Reading path

1. Markers 1 and 2, top of the column: the code units Deploy-Bicep and Get-BicepResourceName.
2. Markers 3 to 6, inside the GUARDED band, top to bottom: the code units lookup, omit + form, format checks and render.
3. Marker 7, right of the band: the failure guard throws, which a red edge from each of the four band steps enters.
4. Marker 8, below the band: the gate -gt limit?.
5. Marker 9, right of the gate: the failure limit throw.
6. Marker 10, below the gate: the result return $name.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                          |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------- |
| code unit             | 6     | Deploy-Bicep, Get-BicepResourceName (above the band); lookup, omit + form, format checks, render (in the band) |
| gate                  | 1     | -gt limit? (below the band)                                                                                    |
| result                | 1     | return $name (bottom of the column)                                                                            |
| failure               | 2     | guard throws (tall, right of the band), limit throw (right of the gate)                                        |

Code units are slate with white names; the gate is grey with a thick rim.

## Edges

| Edge kind    | Count | From → to                                                                                                        |
| ------------ | ----- | ---------------------------------------------------------------------------------------------------------------- |
| flow         | 7     | Deploy-Bicep → Get-BicepResourceName → lookup → omit + form → format checks → render → -gt limit? → return $name |
| failure path | 5     | lookup, omit + form, format checks, render → guard throws; -gt limit? → limit throw                              |

Every edge is straight; the flow edges are vertical and the failure paths horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                         |
| ----------------------- | ------------------------------ |
| slate rounded box       | code unit                      |
| grey rhombus, thick rim | gate                           |
| green rounded box       | result                         |
| red rounded box         | failure                        |
| grey arrow              | flow: calls, in code order     |
| red arrow               | failure path                   |
| dark disc `1`           | marker: a Walkthrough step     |
| grey band               | band: steps whose guards throw |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-naming--lookup-form-check-render-in-order--implementation.grid.md),
[tree](../.assets/tree/adr-az-naming--lookup-form-check-render-in-order--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-az-naming--lookup-form-check-render-in-order--implementation.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
