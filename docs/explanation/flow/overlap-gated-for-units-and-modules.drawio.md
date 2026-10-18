# A gate checks overlap for units and modules, and loose-filesets are exempt: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands.
Glyphs: 3 named sets (mauve), 2 ADR-only (dashed white), 2 gates (grey); 3 flow edges.
Marks: 9 rule chips, 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](overlap-gated-for-units-and-modules.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three named sets, two ADR-only glyphs and two gates, joined
by three flow edges, with nine rule chips, seven markers and a legend panel. The eye lands first on the gate `Independence gate` at the
right of the top band and its long vertical edge down to the bottom band.

## Reading path

1. Marker 1, top band, left: the ADR-only glyph No phantom unit, chip G7.
2. Marker 2, top band: the named set deployable-unit sets, chip G10.
3. Marker 3, on the top vertex of the gate `Independence gate`, chip T35, with edges left to deployable-unit sets and down to module sets.
4. Marker 4, middle band, left: the ADR-only glyph Demonstrated use, chip G7.
5. Marker 5, middle band: the named set loose-fileset sets, chip G10, with no edge.
6. Marker 6, bottom band: the wide named set module sets, chips G7 and G10.
7. Marker 7, on the top vertex of the gate Config-load validation, chips G7 and R7, with a short edge left to module sets.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------- |
| named set             | 3     | deployable-unit sets (top), loose-fileset sets (middle), module sets (bottom, wide)    |
| ADR-only              | 2     | No phantom unit (top, left), Demonstrated use (middle, left)                           |
| gate                  | 2     | `Independence gate` (top band, right), Config-load validation (bottom band, far right) |

Named sets are mauve with white names; the ADR-only glyphs are white with a dashed rim; the gates are grey rhombuses with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                                                                           |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | `Independence gate` → deployable-unit sets, `Independence gate` → module sets, Config-load validation → module sets |

Every edge is straight and none crosses another. The two ADR-only glyphs and loose-fileset sets have no edge.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                                                     |
| ----------------- | -------------------------------------------------------------------------- |
| mauve rounded box | named set                                                                  |
| dashed white box  | ADR-only: no code checks it                                                |
| grey rhombus      | gate                                                                       |
| thin arrow        | flow: checks                                                               |
| dark disc `1`     | marker: a Walkthrough step                                                 |
| white chip `G7`   | rule chip: G = ADR-FLOW-CD-GLOBS, T = ADR-AUTO-TEST, R = ADR-REPO-PROTGLOB |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--overlap-gated-for-units-and-modules--governance.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
