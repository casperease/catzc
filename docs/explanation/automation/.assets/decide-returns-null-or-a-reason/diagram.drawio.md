# Main loads the limits and the run environment, then Decide returns null or a reason: the diagram described

```text
A 1572 x 710 diagram, read top to bottom through four bands.
Glyphs: 2 files (olive), 4 code units (slate), 1 result, 1 failure; 6 flow edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the diagram glyphs; what it means is in
[the article](../../decide-returns-null-or-a-reason.md).

## At a glance

A 1572 × 710 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through four
full-width bands, labelled `LOAD`, `DECIDE`, `VERDICT` and `LOG`. It holds eight glyphs, two files, four code units, one result and one
failure, joined by six flow edges and one failure path, with eight markers and a legend panel along the bottom. The eye lands first on the
wide code unit across the middle of the `DECIDE` band, with two edges coming down into it and three leaving it.

## Reading path

1. Markers 1, 2 and 3, `LOAD` band, left to right: the file timeouts.yml, a flow edge into the code unit TimeoutsConfig, then the code unit
   BashSafeguard.EnvironmentOf.
2. Down two flow edges to marker 4, `DECIDE` band: the wide code unit BashSafeguard.Decide; a flow edge leaves it to the right to marker 5,
   the code unit BoundedCommand.Check.
3. Down from Decide to the `VERDICT` band: a flow edge to marker 6, the result let through, no output, on the left, and a failure path to
   marker 7, the failure DenyOutput: deny + reason, on the right.
4. Down the flow edge from the failure to marker 8, `LOG` band: the file out/time-safeguard.log.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                 |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| file                  | 2     | timeouts.yml (`LOAD` band, left), out/time-safeguard.log (`LOG` band)                                                 |
| code unit             | 4     | TimeoutsConfig, BashSafeguard.EnvironmentOf (`LOAD` band); BashSafeguard.Decide, BoundedCommand.Check (`DECIDE` band) |
| result                | 1     | let through, no output (`VERDICT` band, left)                                                                         |
| failure               | 1     | DenyOutput: deny + reason (`VERDICT` band, right)                                                                     |

Code units are slate and files olive, both with light names; the result is green and the failure red, the only red on the page.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 6     | timeouts.yml → TimeoutsConfig, TimeoutsConfig → Decide, EnvironmentOf → Decide, Decide → BoundedCommand.Check, Decide → let through, DenyOutput → out/time-safeguard.log |
| failure path | 1     | Decide → DenyOutput                                                                                                                                                      |

Every edge is straight, five vertical and two horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| green rounded box | result                     |
| red rounded box   | failure                    |
| light arrow       | flow: feeds the next step  |
| red arrow         | failure path               |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions, [world map](grid.md), [tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
