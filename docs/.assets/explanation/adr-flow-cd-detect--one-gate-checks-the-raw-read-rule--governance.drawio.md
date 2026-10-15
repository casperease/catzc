---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-detect--one-gate-checks-the-raw-read-rule--governance.drawio.md
    kind: asset-description
    body_sha: "4cb4d72923c0"
    adrs: []
---

# One gate checks the raw-read rule: the diagram described

```text
A 1572 x 640 diagram, read left to right across two bands, then down to a third.
Glyphs: 2 code units (slate), 1 named set (mauve), 2 gates (neutral); 1 thick edge, 2 flow edges; 2 solid and 5 dashed rule chips; 5 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-detect--one-gate-checks-the-raw-read-rule--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/one-gate-checks-the-raw-read-rule.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right across two bands
on the top row, `DETECTION` and `CONSUMERS`, then down into a full-width band, `ENFORCEMENT`. It holds five glyphs: two code units, one
named set and two gates, joined by one thick edge and two flow edges. Seven rule chips sit above the three glyphs on the top row, two solid
and five dashed, and five markers number the glyphs. A legend panel runs along the bottom. The eye lands first on the mauve named set in the
`CONSUMERS` band, the only colour on the top row.

## Reading path

1. Marker 1, `DETECTION` band, top: the code unit Test-IsRunningInPipeline, with the chips `D4` (solid) and `D5` (dashed) above it.
2. Marker 2, `DETECTION` band, below it: the code unit Assert-BashTimeout, with a dashed `D1` above it and no edge.
3. Along the thick edge from marker 1 to marker 3, `CONSUMERS` band: the named set consumers, with the chips `D1` (solid), `D2`, `D3` and
   `P3` (dashed) above it.
4. Down the flow edge from marker 1 to marker 4, `ENFORCEMENT` band, left: the gate Test-IsRunning…Tests.ps1.
5. Down the flow edge from marker 3 to marker 5, `ENFORCEMENT` band, right: the gate Measure-…PipelineDetection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| code unit             | 2     | Test-IsRunningInPipeline, Assert-BashTimeout (`DETECTION` band, stacked)                          |
| named set             | 1     | consumers (`CONSUMERS` band)                                                                      |
| gate                  | 2     | Test-IsRunning…Tests.ps1 (`ENFORCEMENT`, left), Measure-…PipelineDetection (`ENFORCEMENT`, right) |

Code units are slate and the named set is mauve, all with light names; the gates are neutral rhombi with a thick light rim. The rule chips
are small dark pills with a light rim and a bold two-character label; a dashed rim marks the five dashed ones.

## Edges

| Edge kind                 | Count | From → to                                                                                   |
| ------------------------- | ----- | ------------------------------------------------------------------------------------------- |
| thick, to a named set     | 1     | Test-IsRunningInPipeline → consumers                                                        |
| flow: feeds the next step | 2     | Test-IsRunningInPipeline → Test-IsRunning…Tests.ps1; consumers → Measure-…PipelineDetection |

The thick edge is horizontal and the two flow edges are vertical. None crosses another, and none carries a label. Assert-BashTimeout has no
edge.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                                     |
| ----------------- | ---------------------------------------------------------- |
| slate rounded box | code unit                                                  |
| mauve rounded box | named set                                                  |
| neutral rhombus   | gate                                                       |
| thin arrow        | flow: feeds the next step                                  |
| thick arrow       | to a named set                                             |
| solid chip `D1`   | rule chip: D = ADR-FLOW-CD-DETECT#n, P = ADR-AUTO-PARITY#n |
| dashed chip `D3`  | dashed rule chip: ADR-only (no gate)                       |
| light disc `1`    | marker: a Walkthrough step                                 |

## Sidebar

The lens badge reads `GOV`. The three minimaps sit above it, and the map key below it names the four swatches.
