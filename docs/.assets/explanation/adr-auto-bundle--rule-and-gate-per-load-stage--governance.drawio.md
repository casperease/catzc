# docs/.assets/explanation/adr-auto-bundle--rule-and-gate-per-load-stage--governance.drawio.md

`Every load stage but the unload has an ADR rule: the diagram described`

```text
A 1572 x 720 diagram, read top to bottom through six stage bands and an ADR-only frame.
Glyphs: 5 gates, 2 ADR-only; no edges; 12 rule chips; 8 markers.
Sidebar: axis minimap (main cell AUTO x LOAD), tree minimap, lens badge GOV, map key.
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

**Rule chips:** 12 in all. SHIM: `R1`, `O1`; SESSION: `E1`, `B2`, `B8`; LOAD: `B3`, `T10`; RUN MODE: `D5`; JANITORS: `R4`, `T13`; UNLOAD:
none; the two ADR-only glyphs: `D1` each.

## Legend

A full-width panel at the bottom of the drawing area, in three columns and a full-width third row:

| Swatch                  | Phrase                                                                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| grey rhombus, thick rim | gate                                                                                                                                 |
| dashed white box        | ADR-only                                                                                                                             |
| white chip `#3`         | rule chip: an ADR rule on the stage                                                                                                  |
| grey band               | band: one load stage                                                                                                                 |
| dark disc `1`           | marker: a Walkthrough step                                                                                                           |
| text row                | chip letters: B ADR-AUTO-BUNDLE · D ADR-DSGN-RUNMODE · E ADR-AUTO-ERROR · O ADR-PRIN-ONELIVE · R ADR-REPO-ROOTCFG · T ADR-AUTO-TYPES |

## Sidebar

- **Axis minimap:** the main cell is AUTO × LOAD, framed and filled in the LOAD indigo with the you-are-here dot. Four touched cells carry a
  small grey dot: PRIN × BUILD, DSGN × LOAD, DSGN × CONFIG and AUTO × BUILD.
- **Tree minimap:** lit tiles labelled ModuleSystem, .internal, adr/auto, adr/repo, adr/prin, adr/dsgn and .claude.
- **Lens badge:** GOV. Beneath it, three lines at 10.5 px read "Supports ADR-AUTO-BUNDLE", "ADR-AUTO-TYPES · ADR-DSGN-RUNMODE" and
  "ADR-PRIN-ONELIVE · ADR-REPO-ROOTCFG".
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
