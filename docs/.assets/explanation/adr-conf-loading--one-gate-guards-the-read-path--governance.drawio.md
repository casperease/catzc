---
catzc:
  immutable:
    with_body_sha: "8df1cbc22515"
    path: docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-conf-loading-one-gate-guards-the-read-path-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.png
      - docs/.assets/explanation/chain/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md
      - docs/.assets/explanation/grid/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md
      - docs/.assets/explanation/tree/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md
      - docs/explanation/configuration/one-gate-guards-the-read-path.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One gate guards the read path: the diagram described

```text
A 1572 x 700 diagram, read left to right along one band, down into two bands, with a band of gates at the bottom pointing up.
Glyphs: 2 code units (slate), 1 store (slate), 3 ADR-only boxes, 2 gates; 7 flow edges; 8 markers; 8 rule chips.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-conf-loading--one-gate-guards-the-read-path--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/configuration/one-gate-guards-the-read-path.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right along a
full-width band labelled READ PATH, down into two bands side by side, EXTENSION POINT on the left and MISS on the right, and a full-width
band labelled QUALITY GATES at the bottom whose glyphs point up. It holds eight glyphs (two code units, one store, three ADR-only boxes and
two gates) joined by seven edges, with eight markers, eight rule chips and a legend panel along the bottom. The eye lands first on the two
dashed boxes at either end of the READ PATH band.

## Reading path

1. Markers 1 to 4, READ PATH band, left to right: the ADR-only box one reader, the code unit resolution, the store session cache and the
   ADR-only box a read, not a copy.
2. Marker 5, EXTENSION POINT band: the ADR-only box PowerShell validator.
3. Down from the store to marker 6, MISS band: the wide code unit typed once, whose right part sends an edge up into a read, not a copy.
4. Markers 7 and 8, QUALITY GATES band: the gates Test-ConfigValidators (left, edge up into PowerShell validator) and Test-ShippedConfigs
   (middle, edge up into typed once).

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                              |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------- |
| code unit             | 2     | resolution (READ PATH), typed once (MISS, wide)                                                    |
| store                 | 1     | session cache (READ PATH, middle)                                                                  |
| ADR-only              | 3     | one reader and a read, not a copy (READ PATH, both ends), PowerShell validator (EXTENSION POINT)   |
| gate                  | 2     | Test-ConfigValidators and Test-ShippedConfigs (QUALITY GATES), each a grey rhombus with a 3 px rim |

Code units and the store are slate with white names; the ADR-only boxes are white with a dashed rim.

Rule chips sit on the top-right of each glyph (on the upper-right edge of a gate): `L1 L6`, `L2 A1 A2 A4`, `L3`, `A3 A5`, `L5`, `L4`,
`L5 T35` and `L4 T35`.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 7     | one reader → resolution, resolution → session cache, session cache → a read, not a copy, session cache → typed once, typed once → a read, not a copy, Test-ShippedConfigs → typed once, Test-ConfigValidators → PowerShell validator |

Every edge is straight and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                 | Phrase                                          |
| ---------------------- | ----------------------------------------------- |
| slate rounded box      | code unit                                       |
| slate cylinder         | store                                           |
| grey rhombus, 3 px rim | gate                                            |
| white dashed box       | ADR-only                                        |
| thin arrow             | flow: the read, or what a gate checks           |
| white chip `L4`        | rule chip: L LOADING, A ADDRESSING, T AUTO-TEST |
| dark disc `1`          | marker: a Walkthrough step                      |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-TEST, ADR-CONF-ADDRESSING and ADR-CONF-LOADING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](grid/adr-conf-loading--one-gate-guards-the-read-path--governance.grid.md),
[tree](tree/adr-conf-loading--one-gate-guards-the-read-path--governance.tree.md) and [value-chain map](chain/adr-conf-loading--one-gate-guards-the-read-path--governance.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-TEST, ADR-CONF-ADDRESSING and ADR-CONF-LOADING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
