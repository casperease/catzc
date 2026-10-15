---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.drawio.md
    kind: asset-description
    body_sha: "05e637848678"
    adrs: []
---

# Tests pin the throw and the fail-open, no caller: the diagram described

```text
A 1572 x 760 diagram, read top to bottom through four bands, each band a row with the governed glyph left and its gate right.
Glyphs: 3 code units (slate), 3 gates, 2 ADR-only; 3 flow edges; 6 rule chips (3 dashed); 8 markers.
Sidebar: three minimaps and the map key.
```

This describes what the [diagram](adr-flow-cd-globs--tests-pin-the-throw-and-fail-open-no-caller--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/flow/tests-pin-the-throw-and-fail-open-no-caller.md).

## At a glance

A 1572 × 760 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `THE NAME AND THE ANSWER`, `THE RANGE`, `THE CONTEXT` and `NO GATE`. Each of the first three bands is one row: a
slate code unit on the left and a gate rhombus on the right, joined by one flow edge pointing left. The last band holds two dashed ADR-only
glyphs and no edge. Six rule chips sit on the top-right corners of the governed glyphs, eight markers on their top-left corners, and a
legend panel runs along the bottom. The eye lands first on the three grey rhombi in the right column.

## Reading path

1. Marker 1, `THE NAME AND THE ANSWER` band: the code unit Test-GlobSetAffected, rule chips `G9` and dashed `F4`; right along the flow edge,
   against its arrow, to marker 2: the gate Test-GlobSetAffected.Tests.
2. Marker 3, `THE RANGE` band: the code unit Get-GlobSetChangeRange, rule chip `G9`; marker 4: the gate Get-GlobSetChangeRange.Tests.
3. Marker 5, `THE CONTEXT` band: the code unit Test-IsRunningInPipeline, rule chip `D1`; marker 6: the gate Test-ScriptAnalyzer.
4. Marker 7, `NO GATE` band: the ADR-only glyph fetchDepth: 0, dashed rule chip `G9`; marker 8: the ADR-only glyph a stage runs the check
   first, dashed rule chip `G9`. Both are joined to nothing.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Test-GlobSetAffected (`THE NAME AND THE ANSWER`), Get-GlobSetChangeRange (`THE RANGE`), Test-IsRunningInPipeline (`THE CONTEXT`), left column |
| gate                  | 3     | Test-GlobSetAffected.Tests, Get-GlobSetChangeRange.Tests, Test-ScriptAnalyzer, right column, 3 px rims                                        |
| ADR-only              | 2     | fetchDepth: 0 and a stage runs the check first (`NO GATE`), dashed outlines                                                                   |

Code units are slate with white names, the gates neutral rhombi, and the ADR-only glyphs dashed outlines on the page.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                |
| ------------ | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: checks | 3     | Test-GlobSetAffected.Tests → Test-GlobSetAffected; Get-GlobSetChangeRange.Tests → Get-GlobSetChangeRange; Test-ScriptAnalyzer → Test-IsRunningInPipeline |

Every edge is straight and horizontal, and none crosses another. No edge carries a label. Six rule chips sit beside the glyphs they govern:
`G9` and dashed `F4` on Test-GlobSetAffected, `G9` on Get-GlobSetChangeRange, `D1` on Test-IsRunningInPipeline, and a dashed `G9` on each
ADR-only glyph.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                                                          |
| ----------------- | ------------------------------------------------------------------------------- |
| slate rounded box | code unit                                                                       |
| neutral rhombus   | gate                                                                            |
| dashed outline    | ADR-only                                                                        |
| thin arrow        | flow: checks                                                                    |
| chip `G9`         | rule chip: G = ADR-FLOW-CD-GLOBS, D = ADR-FLOW-CD-DETECT, F = ADR-AUTO-FAILFAST |
| dashed chip `G9`  | dashed rule chip: ADR-only (no gate)                                            |
| light disc `1`    | marker: a Walkthrough step                                                      |

## Sidebar

The lens badge reads `GOV`. The three minimaps sit above it, and the map key below it names the four swatches: lit, lit by passing mentions
only, lit ADR file, idle.
