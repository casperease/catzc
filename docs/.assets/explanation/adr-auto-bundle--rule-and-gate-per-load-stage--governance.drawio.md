---
catzc:
  immutable:
    with_body_sha: "17e7b978f7b4"
    path: docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-bundle-rule-and-gate-per-load-stage-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md
      - docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md
      - docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md
      - docs/explanation/automation/rule-and-gate-per-load-stage.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every load stage but the unload has an ADR rule: the diagram described

```text
A 1572 x 720 diagram, read top to bottom through six stage bands and an ADR-only frame.
Glyphs: 5 gates, 2 ADR-only; no edges; 12 rule chips; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/rule-and-gate-per-load-stage.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through six
full-width bands, one per load stage, labelled SHIM, SESSION, LOAD, RUN MODE, JANITORS and UNLOAD, under two column heads, RULES and GATE.
Beneath the bands a frame labelled ADR-ONLY holds two ADR-only glyphs. It holds seven glyphs, five gates and two ADR-only, with no edges,
twelve rule chips, eight markers and a legend panel along the bottom. The eye lands first on the column of five rhombuses in the middle of
the bands, and on the empty sixth band.

## Reading path

1. Markers 1 to 5, on the top-left corners of the first five bands: in each band, left to right, the band label, its rule chips under RULES,
   and a gate under GATE with its name beside it.
2. Marker 6, on the UNLOAD band's corner: the band holds no chip and no gate.
3. Markers 7 and 8, ADR-ONLY frame: the ADR-only glyphs build-catzc.ps1 and Write-CatzcLoadBanner, each with a rule chip `D1` to its right.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| gate                  | 5     | one per band in rows 1 to 5, each named beside it: New-Importer.Tests, code review, Import-AllModules.Tests, Assert-CatzcRunModeExclusive.Tests, Invoke-TypeCacheJanitor.Tests |
| ADR-only              | 2     | ADR-ONLY frame: build-catzc.ps1 (left), Write-CatzcLoadBanner (centre)                                                                                                         |

Gates are light grey rhombuses with a thick rim; ADR-only glyphs are white rounded boxes with a dashed rim.

## Edges

None. Each gate sits inside the band of the stage it checks, and the ADR-only glyphs stand alone in their frame.

**Rule chips:** 12 in all. SHIM: `R1`, `O1`; SESSION: `E1`, `B2`, `B8`; LOAD: `B3`, `P2`; RUN MODE: `D5`; JANITORS: `R4`, `T13`; UNLOAD:
none; the two ADR-only glyphs: `D1` each.

## Legend

A full-width panel at the bottom of the drawing area, in three columns and a full-width third row:

| Swatch                  | Phrase                                                                                                                                                  |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| grey rhombus, thick rim | gate                                                                                                                                                    |
| dashed white box        | ADR-only                                                                                                                                                |
| white chip `#3`         | rule chip: an ADR rule on the stage                                                                                                                     |
| grey band               | band: one load stage                                                                                                                                    |
| dark disc `1`           | marker: a Walkthrough step                                                                                                                              |
| text row                | chip letters: B ADR-AUTO-BUNDLE · D ADR-DSGN-RUNMODE · E ADR-PWSH-ERROR · O ADR-PRIN-ONELIVE · P ADR-PWSH-TYPES · R ADR-REPO-ROOTCFG · T ADR-AUTO-TYPES |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-auto-bundle--rule-and-gate-per-load-stage--governance.grid.md),
[tree](adr-auto-bundle--rule-and-gate-per-load-stage--governance.tree.md) and [value-chain map](adr-auto-bundle--rule-and-gate-per-load-stage--governance.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
