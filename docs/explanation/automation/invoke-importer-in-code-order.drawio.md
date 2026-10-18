---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/automation/invoke-importer-in-code-order.drawio.md
    folder: docs/explanation/automation
    name: invoke-importer-in-code-order-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.png
      - docs/explanation/.assets/chain/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md
      - docs/explanation/.assets/grid/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md
      - docs/explanation/.assets/tree/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md
      - docs/explanation/automation/invoke-importer-in-code-order.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Invoke-Importer loads, asserts one run mode, tidies up and unloads, in one call chain: the diagram described

```text
A 1572 x 822 diagram, read top to bottom down one column in one band.
Glyphs: 8 code units (slate), 1 gate; 8 flow edges; 9 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](invoke-importer-in-code-order.md).

## At a glance

A 1572 × 822 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band labelled CALL ORDER. It holds nine glyphs, eight code units and one gate, joined by eight straight edges, with nine markers
and a legend panel along the bottom. The eye lands first on the wide rhombus, the gate, two-thirds of the way down the column.

## Reading path

1. Marker 1, top of the left column: the code unit importer.ps1.
2. Down the column, markers 2 to 5: the code units Invoke-Importer, Import-InternalModule, Import-VendorModules and Import-AllModules.
3. Marker 6, on the gate's left point: the gate Assert-CatzcRunModeExclusive.
4. Markers 7 and 8: the code units Janitors and Remove-Module.
5. Marker 9, to the right of Invoke-Importer: the code unit Import-Catzc.ps1, whose edge enters Invoke-Importer from the right.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------- |
| code unit             | 8     | seven in the left column, one (Import-Catzc.ps1) to the right of the second row |
| gate                  | 1     | Assert-CatzcRunModeExclusive, sixth in the left column                          |

Code units are slate with white names; the gate is a light grey rhombus with a thick rim.

## Edges

| Edge kind         | Count | From → to                                                                                               |
| ----------------- | ----- | ------------------------------------------------------------------------------------------------------- |
| flow (calls next) | 8     | seven down the left column, each glyph to the next; one from Import-Catzc.ps1 left into Invoke-Importer |

Every edge is straight; none crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| thin arrow              | flow: calls next           |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md),
[tree](../.assets/tree/adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
