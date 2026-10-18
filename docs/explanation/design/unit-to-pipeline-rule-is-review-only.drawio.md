# Tracks and deployable-units have a gate in code, but one unit to one pipeline is held by review alone: the diagram described

```text
A 1572 x 600 diagram, three bands side by side, each read top to bottom.
Glyphs: 3 named sets (mauve), 1 runner (slate), 3 gates, 1 ADR-only gate; 5 edges; 8 markers; 4 rule chips.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](unit-to-pipeline-rule-is-review-only.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three side-by-side bands, labelled TRACKS,
DEPLOYABLE-UNITS and PIPELINES · SCOPES, each read top to bottom: the constrained glyph above, its check below. It holds eight glyphs (three
named sets, one runner, three gates and one ADR-only gate) joined by five downward edges, with eight markers, four rule chips and a legend
panel along the bottom. The eye lands first on the large white rhombus in its dashed frame in the right band.

## Reading path

1. Marker 1, TRACKS band, top: the named set track, with the rule chip T1–4 · T6 · F1,3.
2. Down two edges to markers 2 and 3: the gates VariantsConfig and Get-FileLanguage.Tests.
3. Marker 4, DEPLOYABLE-UNITS band, top: the named set deployable-unit, with the rule chip G7 · G8; down to marker 5, the gate GlobsConfig.
4. Markers 6 and 7, PIPELINES · SCOPES band, top: the runner pipeline (chip T5) and the named set `scope globset` (chip T2).
5. Down two dashed edges to marker 8: the ADR-only gate code review, inside a dashed frame.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                               |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| named set             | 3     | track (TRACKS, top), deployable-unit (DEPLOYABLE-UNITS, top), scope globset (right band, top right) |
| runner                | 1     | pipeline (right band, top left)                                                                     |
| gate                  | 3     | VariantsConfig, Get-FileLanguage.Tests (TRACKS, bottom), GlobsConfig (DEPLOYABLE-UNITS, bottom)     |
| ADR-only              | 1     | code review (right band, bottom), a white rhombus inside a dashed frame                             |

Named sets are mauve and the runner slate, both with white names; the gates are grey rhombi with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                             |
| --------- | ----- | ------------------------------------------------------------------------------------- |
| flow      | 3     | track → VariantsConfig, track → Get-FileLanguage.Tests, deployable-unit → GlobsConfig |
| ADR-only  | 2     | pipeline → code review, scope globset → code review                                   |

Every edge is straight and vertical, and none crosses another. Four rule chips sit on the top-right corners of the four upper glyphs.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                                                     |
| ----------------------- | -------------------------------------------------------------------------- |
| mauve rounded box       | named set                                                                  |
| slate pill              | runner                                                                     |
| grey rhombus, thick rim | gate                                                                       |
| dashed white box        | ADR-only: review, no code (glyph or edge)                                  |
| thin arrow              | flow: is checked by                                                        |
| white chip `T5`         | rule chip: T = ADR-DSGN-TRACK, G = ADR-FLOW-CD-GLOBS, F = ADR-REPO-FOLDERS |
| dark disc `1`           | marker: a Walkthrough step                                                 |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md),
[tree](../.assets/tree/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS and ADR-REPO-FOLDERS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
