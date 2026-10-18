# Every load stage but the unload has an ADR rule and a gate: the diagram described

```text
A 1572 x 720 diagram, read top to bottom through six stage bands.
Glyphs: 5 gates; no edges; 10 rule chips; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../rule-and-gate-per-load-stage.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through six
full-width bands, one per load stage, labelled SHIM, SESSION, LOAD, RUN MODE, JANITORS and UNLOAD, under two column heads, RULES and GATE.
It holds five glyphs, all gates, with no edges, ten rule chips, six markers and a legend panel along the bottom, below an empty strip where
no glyph is drawn. The eye lands first on the column of five rhombuses in the middle of the bands, and on the empty sixth band.

## Reading path

1. Markers 1 to 5, on the top-left corners of the first five bands: in each band, left to right, the band label, its rule chips under RULES,
   and a gate under GATE with its name beside it.
2. Marker 6, on the UNLOAD band's corner: the band holds no chip and no gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| gate                  | 5     | one per band in rows 1 to 5, each named beside it: New-Importer.Tests, code review, Import-AllModules.Tests, Assert-CatzcRunModeExclusive.Tests, Invoke-TypeCacheJanitor.Tests |

Gates are light grey rhombuses with a thick rim.

## Edges

None. Each gate sits inside the band of the stage it checks.

**Rule chips:** 10 in all. SHIM: `R1`, `O1`; SESSION: `E1`, `B2`, `B8`; LOAD: `B3`, `P2`; RUN MODE: `D5`; JANITORS: `R4`, `T13`; UNLOAD:
none.

## Legend

A full-width panel at the bottom of the drawing area, in three columns and a full-width third row:

| Swatch                  | Phrase                                                                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| grey rhombus, thick rim | gate                                                                                                                                                    |
| white chip `#3`         | rule chip: an ADR rule on the stage                                                                                                                     |
| grey band               | band: one load stage                                                                                                                                    |
| dark disc `1`           | marker: a Walkthrough step                                                                                                                              |
| text row                | chip letters: B ADR-AUTO-BUNDLE · D ADR-DSGN-RUNMODE · E ADR-PWSH-ERROR · O ADR-PRIN-ONELIVE · P ADR-PWSH-TYPES · R ADR-REPO-ROOTCFG · T ADR-AUTO-TYPES |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
