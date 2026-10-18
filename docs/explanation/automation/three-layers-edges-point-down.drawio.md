# Module dependencies form three layers, and every edge points down: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 code units (slate); 7 downward edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-depm--three-layers-edges-point-down--architecture.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](three-layers-edges-point-down.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `TOP LAYER`, `MIDDLE LAYER` and `FOUNDATION`. It holds five glyphs, three named sets and two code units, joined
by seven downward edges, with six markers and a legend panel along the bottom. The eye lands first on the wide named set in the foundation
band, which nearly spans the drawing area.

## Reading path

1. Marker 1, top band: the named set AzureExt, centred left.
2. Down the four edges that leave it, to the middle band.
3. Markers 2, 3 and 4, middle band, left to right: the code unit Catzc.Azure, the named set Tooling, the code unit Github · KeyHandler.
4. Marker 6, touching the thin edge that enters Tooling from AzureExt.
5. Down to marker 5, foundation band: the named set Base.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------- |
| named set             | 3     | AzureExt (top band), Tooling (middle band, centre), Base (foundation band, full width) |
| code unit             | 2     | Catzc.Azure (middle band, left), Github · KeyHandler (middle band, right)              |

Named sets are mauve and code units are slate, both with white names.

## Edges

| Edge kind              | Count | From → to                                                                                           |
| ---------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| thick, to a named set  | 5     | AzureExt → Base, AzureExt → Tooling, Catzc.Azure → Base, Tooling → Base, Github · KeyHandler → Base |
| flow, to one code unit | 2     | AzureExt → Catzc.Azure, AzureExt → Tooling (marker 6)                                               |

Every edge is straight and vertical, and none crosses another. Five carry a fraction chip: 4/5, 3/5 and 5/5 on the edges that leave
AzureExt, 6/6 below Tooling, and 2/2 below Github · KeyHandler.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| mauve rounded box | named set                            |
| slate rounded box | code unit                            |
| thick arrow       | may depend on, to a named set        |
| thin arrow        | may depend on, to one code unit      |
| bold `4/5`        | fraction chip: members with the edge |
| dark disc `1`     | marker: a Walkthrough step           |
| grey band         | band: one layer                      |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEPM): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-depm--three-layers-edges-point-down--architecture.grid.md),
[tree](../.assets/tree/adr-auto-depm--three-layers-edges-point-down--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-auto-depm--three-layers-edges-point-down--architecture.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AUTO-DEPM" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
