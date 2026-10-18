# Gates check the source of each globset and the trigger, but not the git reflection or the identity: the diagram described

```text
A 1572 x 640 diagram, read left to right through five bands.
Glyphs: 1 file (olive), 4 code units (slate), 3 gates; 7 flow edges; 8 markers, 8 rule chips.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--gates-check-source-and-trigger--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](gates-check-source-and-trigger.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through five
bands side by side, labelled `SOURCE`, `LOAD`, `FLATTEN`, `ROLES` and `CHECKED BY`. It holds eight glyphs, one file, four code units and
three gates, joined by seven edges, with eight markers, eight rule chips and a legend panel along the bottom. The eye lands first on the
tall code unit in the FLATTEN band, then on the two empty rows of the CHECKED BY band.

## Reading path

1. Marker 1, SOURCE band, middle row: the file Registry.
2. Down its edge to marker 2, SOURCE band, bottom: the gate Test-GlobSetIndependence, marked at its left vertex.
3. Right from Registry to marker 3, LOAD band: the gate Config load, marked at its top vertex.
4. Right to marker 4, FLATTEN band: the tall code unit Scan program.
5. Right along three parallel edges to the ROLES band: marker 5 on Native projection (top row), then its edge to marker 6, the gate
   `Trigger gates` in the CHECKED BY band, marked at its top vertex.
6. Markers 7 and 8, ROLES band: the code units Git reflection (middle row) and Live identity (bottom row). No edge leaves either; the
   CHECKED BY band is empty in their rows.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                               |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | Registry (SOURCE band, middle row)                                                                                  |
| gate                  | 3     | Test-GlobSetIndependence (SOURCE band, bottom), Config load (LOAD band), `Trigger gates` (CHECKED BY band, top row) |
| code unit             | 4     | Scan program (FLATTEN band, all rows); Native projection, Git reflection, Live identity (ROLES band, one per row)   |

The file is olive and the code units are slate, both with white names. Every gate is grey with a 3 px rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                 |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | Registry → Test-GlobSetIndependence (down); Registry → Config load → Scan program; Scan program → each of the three ROLES code units; Native projection → `Trigger gates` |

Every edge is straight; none crosses another.

## Rule chips

Eight white chips sit on the top edge of the glyph they govern: G1 · G7 · G10 (Registry), G10 · T35 (Test-GlobSetIndependence), G3 · G8
(Config load), G2 · G4 · G8 (Scan program), G6 (Native projection), G9 (Git reflection), G5 (Live identity) and G6 · T35 (`Trigger gates`).

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                                              |
| ---------------------- | --------------------------------------------------- |
| olive folded page      | file                                                |
| slate rounded box      | code unit                                           |
| grey rhombus, 3 px rim | gate                                                |
| thin arrow             | flow: output read by the next                       |
| white chip `G6`        | rule chip: G = ADR-FLOW-CD-GLOBS, T = ADR-AUTO-TEST |
| dark disc `1`          | marker: a Walkthrough step                          |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--gates-check-source-and-trigger--governance.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--gates-check-source-and-trigger--governance.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--gates-check-source-and-trigger--governance.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-TEST and ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
