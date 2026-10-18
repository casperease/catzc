# Two entry scripts feed one importer, and the importer leaves once the load is done: the diagram described

```text
A 1572 x 700 diagram, read top to bottom, then left to right, through three bands.
Glyphs: 4 code units (slate), 4 named sets (mauve); 7 edges; 9 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../two-entries-feed-one-importer.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom, then left to
right. A full-width band labelled ENTRY sits above two side-by-side bands, REMOVED AFTER LOAD (left, wider) and STAYS LOADED (right). It
holds eight glyphs, four code units and four named sets, joined by seven straight edges, with nine markers and a legend panel along the
bottom. The eye lands first on the tall code unit Catzc.Internal.Importer, which fills most of the left band.

## Reading path

1. Markers 1 and 2, ENTRY band: the code units importer.ps1 and Import-Catzc.ps1, side by side.
2. Down the two edges into the importer; marker 3 sits beside the edge from Import-Catzc.ps1, rim touching the line, where it crosses the
   gap between the bands.
3. Marker 4, REMOVED AFTER LOAD band: the code unit Catzc.Internal.Importer.
4. Marker 5, the same band: the code unit Catzc.Internal.Bootstrap, to the importer's right, in the third row.
5. Markers 6 to 9, STAYS LOADED band, top to bottom: the named sets `.internal shared layer`, .vendor, Catzc.\* modules and Janitor owners.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                    |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| code unit             | 4     | importer.ps1, Import-Catzc.ps1 (ENTRY band); Catzc.Internal.Importer, Catzc.Internal.Bootstrap (REMOVED AFTER LOAD band) |
| named set             | 4     | `.internal shared layer`, .vendor, Catzc.\* modules, Janitor owners (STAYS LOADED band, stacked)                         |

Code units are slate and named sets are mauve, both with white names.

## Edges

| Edge kind              | Count | From → to                                                                                                                                         |
| ---------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| thick, to a named set  | 4     | Catzc.Internal.Importer → `.internal shared layer`, → .vendor, → Janitor owners; Catzc.Internal.Bootstrap → Catzc.\* modules                      |
| flow, to one code unit | 3     | importer.ps1 → Catzc.Internal.Importer, Import-Catzc.ps1 → Catzc.Internal.Importer (marker 3), Catzc.Internal.Importer → Catzc.Internal.Bootstrap |

Two edges run straight down from the ENTRY band; the other five run straight right. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                     |
| ----------------- | ------------------------------------------ |
| slate rounded box | code unit                                  |
| mauve rounded box | named set                                  |
| thick arrow       | flow: drives, to a named set               |
| thin arrow        | flow: drives, to one code unit             |
| dark disc `1`     | marker: a Walkthrough step                 |
| grey band         | band: in the session after the load or not |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
