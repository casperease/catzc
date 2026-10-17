---
catzc:
  immutable:
    with_body_sha: eb1557294baf
    repo_status: clean
    path: docs/explanation/pipelines/which-auth-rungs-have-a-gate.drawio.md
    folder: docs/explanation/pipelines
    name: which-auth-rungs-have-a-gate-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.png
      - docs/explanation/.assets/chain/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
      - docs/explanation/.assets/grid/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
      - docs/explanation/.assets/tree/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md
      - docs/explanation/pipelines/which-auth-rungs-have-a-gate.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Which auth rungs have a gate: the diagram described

```text
A 1572 x 620 diagram in two bands side by side, HEADER FUNCTION and CROSS-CUTTING.
Glyphs: 3 gates, 3 code units (slate), 2 runners (slate); 4 flow edges; 9 rule chips (5 solid, 4 dashed); 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](which-auth-rungs-have-a-gate.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two bands sit side by side: HEADER FUNCTION on
the left, with the column headings RUNG and CHECKED BY, and CROSS-CUTTING on the right. They hold eight glyphs (three gates, three code
units, two runners) joined by four edges, with nine rule chips (five solid, four dashed), five markers and a legend panel along the bottom.
The eye lands first on the three gates in the left band.

## Reading path

1. Marker 1, beside the HEADER FUNCTION band label: three rule chips, #1 solid, #4 and #7 dashed.
2. Marker 2, left band, top row: the gate Pipeline token, with chips #3 and #2 (both solid) and a flow edge right to the code unit L0 tests.
3. Marker 3, middle row: the gate PAT, with chip #2 (dashed) and a flow edge right to the code unit L0 test.
4. Marker 4, bottom row: the gate az CLI, with chips #2 (solid) and #5 (dashed) and a flow edge right to the code unit L0 tests.
5. Marker 5, right band: the runner invoke-automation.yaml, with chip #6 (solid) and a flow edge down to the runner AzureAuthTests.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                        |
| --------------------- | ----- | ------------------------------------------------------------ |
| gate                  | 3     | Pipeline token, PAT, az CLI (left band, RUNG column)         |
| code unit             | 3     | L0 tests, L0 test, L0 tests (left band, CHECKED BY column)   |
| runner                | 2     | invoke-automation.yaml, AzureAuthTests (right band, stacked) |

Code units and runners are slate with white names; the gates are grey with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                     |
| --------- | ----- | ----------------------------------------------------------------------------- |
| flow      | 4     | each gate → the code unit on its row; invoke-automation.yaml → AzureAuthTests |

Every edge is straight, horizontal or vertical, and none crosses another. The rule chips sit above the edge that leaves each gate.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                               |
| ----------------------- | ------------------------------------ |
| grey rhombus, thick rim | gate                                 |
| slate rounded box       | code unit                            |
| slate pill              | runner                               |
| grey arrow              | flow: checked by                     |
| white chip `#n`         | rule chip: ADR-PIPE-AUTH#n           |
| dashed white chip `#n`  | dashed rule chip: ADR-only (no gate) |
| dark disc `1`           | marker: a Walkthrough step           |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-PIPE-AUTH): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md),
[tree](../.assets/tree/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md) and
[value-chain map](../.assets/chain/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
