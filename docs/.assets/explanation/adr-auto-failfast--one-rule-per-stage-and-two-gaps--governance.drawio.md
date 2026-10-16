---
catzc:
  immutable:
    with_body_sha: "21e254f9ac30"
    path: docs/.assets/explanation/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-failfast-one-rule-per-stage-and-two-gaps-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.drawio.png
      - docs/.assets/explanation/chain/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.chain.md
      - docs/.assets/explanation/grid/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.grid.md
      - docs/.assets/explanation/tree/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.tree.md
      - docs/explanation/automation/one-rule-per-stage-and-two-gaps.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two rules govern every stage, tests and the hook check them, and two gaps remain: the diagram described

```text
A 1572 x 640 diagram, read left to right through four bands.
Glyphs: 3 code units (slate), 2 files (olive), 3 gates (neutral); 4 flow edges, 1 ADR-only edge; 8 markers; 6 rule chips, 1 dashed.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/one-rule-per-stage-and-two-gaps.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands, labelled `AXES`, `LIMIT`, `RAISE` and `CONSUMERS`. It holds eight glyphs, three code units, two files and three gates, on three rows.
Four flow edges and one dashed ADR-only edge join them, and six rule chips sit beside the glyphs, five solid and one dashed, with eight
markers and a legend panel below the bands. The eye lands first on the three gates, each a rhombus, one per band from `LIMIT`.

## Reading path

1. Marker 1, bottom of the `AXES` band: the code unit Get-RunEnvironment, with the chip `F7` above its right end; its edge runs right along
   the bottom row.
2. Up to marker 2, top of the `LIMIT` band: the file timeouts.yml, chip `F7`; right to marker 3, the code unit TimeoutsConfig, chip `D6`
   above it.
3. Down to marker 4, middle row of the `LIMIT` band: the gate TimeoutsConfig.Tests, where both edges from the row above arrive, one of them
   bent once.
4. Marker 5, top of the `RAISE` band: the file timeout-exemptions.yml, chip `F7`; a solid edge leaves its underside and a dashed edge leaves
   its right side.
5. Down to marker 6, bottom row of the `RAISE` band: the gate Get-TimeoutSeconds.Tests, where the bottom-row edge from `AXES` and the edge
   from the file above arrive.
6. Marker 7, top of the `CONSUMERS` band: the gate Assert-BashTimeout, chip `F7` to its left, where the dashed edge ends.
7. Down to marker 8, bottom row of the `CONSUMERS` band: the code unit Invoke-Executable -Direct, with the dashed chip `F7` above its right
   end and no edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                     |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Get-RunEnvironment (`AXES`), TimeoutsConfig (`LIMIT`, top right), Invoke-Executable -Direct (`CONSUMERS`, bottom)         |
| file                  | 2     | timeouts.yml (`LIMIT`, top), timeout-exemptions.yml (`RAISE`, top)                                                        |
| gate                  | 3     | TimeoutsConfig.Tests (`LIMIT`, middle), Get-TimeoutSeconds.Tests (`RAISE`, bottom), Assert-BashTimeout (`CONSUMERS`, top) |

Code units are slate and files olive, both with white names; gates are neutral dark rhombuses with a light rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                       |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | TimeoutsConfig → TimeoutsConfig.Tests, timeouts.yml → TimeoutsConfig.Tests (down, then right), timeout-exemptions.yml → Get-TimeoutSeconds.Tests, Get-RunEnvironment → Get-TimeoutSeconds.Tests |
| ADR-only  | 1     | timeout-exemptions.yml → Assert-BashTimeout (dashed)                                                                                                                                            |

Three flow edges are straight; the one from timeouts.yml turns once. None crosses another, and none carries a label. Six rule chips sit
beside glyphs: `F7` by Get-RunEnvironment, timeouts.yml, timeout-exemptions.yml and Assert-BashTimeout, `D6` by TimeoutsConfig, and a dashed
`F7` by Invoke-Executable -Direct.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                                             |
| ----------------- | -------------------------------------------------- |
| slate rounded box | code unit                                          |
| olive page        | file                                               |
| neutral rhombus   | gate                                               |
| thin arrow        | flow: is checked by                                |
| dashed arrow      | ADR-only (no code)                                 |
| light disc `1`    | marker: a Walkthrough step                         |
| chip `F7`         | rule chip: F ADR-AUTO-FAILFAST, D ADR-AUTO-DEFAULT |
| dashed chip `F7`  | dashed rule chip: ADR-only (no gate)               |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.grid.md),
[tree](tree/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.tree.md) and
[value-chain map](chain/adr-auto-failfast--one-rule-per-stage-and-two-gaps--governance.chain.md), which hold the reason for every lit cell
or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
