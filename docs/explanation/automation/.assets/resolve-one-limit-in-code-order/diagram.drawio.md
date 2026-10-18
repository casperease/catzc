# Get-TimeoutSeconds resolves the environment, the config entry, then the exemption ceiling, in that order: the diagram described

```text
A 1572 x 640 diagram, read left to right through four bands.
Glyphs: 5 code units (slate), 2 files (olive), 1 gate (neutral); 1 frame; 6 flow edges, 4 labelled; 8 markers; 1 count chip.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../resolve-one-limit-in-code-order.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands, labelled `AXES`, `LIMIT`, `RAISE` and `CONSUMERS`. It holds eight glyphs, five code units, two files and one gate, on three rows,
with a frame in the last band around two code units. Six flow edges join them, four carrying a short label, with eight markers, one count
chip under the first file, and a legend panel below the bands. The eye lands first on the two olive files, one at the top of `LIMIT` and one
in the middle of `RAISE`.

## Reading path

1. Marker 1, bottom of the `AXES` band: the code unit Get-RunEnvironment.
2. Up to marker 2, top of the `LIMIT` band: the file timeouts.yml, with the count chip `22` under it; right to marker 3, the code unit
   TimeoutsConfig.
3. Marker 4, middle row of the `RAISE` band: the file timeout-exemptions.yml.
4. Down to marker 5, bottom row of the `RAISE` band: the code unit Get-TimeoutSeconds, where three edges arrive.
5. Marker 6, top of the `CONSUMERS` band: the gate Assert-BashTimeout.
6. Markers 7 and 8, inside the frame below it: the code units Invoke-Executable and Invoke-WithTimeout.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | Get-RunEnvironment (`AXES`), TimeoutsConfig (`LIMIT`), Get-TimeoutSeconds (`RAISE`), Invoke-Executable and Invoke-WithTimeout (`CONSUMERS`, in the frame) |
| file                  | 2     | timeouts.yml (`LIMIT`, top), timeout-exemptions.yml (`RAISE`, middle)                                                                                     |
| gate                  | 1     | Assert-BashTimeout (`CONSUMERS`, top)                                                                                                                     |

Code units are slate and files olive, both with white names; the gate is a neutral dark rhombus with a light rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 6     | timeouts.yml → TimeoutsConfig, Get-RunEnvironment → Get-TimeoutSeconds (`Devbox \| Pipeline`), TimeoutsConfig → Get-TimeoutSeconds (down, then right; `SecondsFor`), TimeoutsConfig → Assert-BashTimeout (`SecondsFor(bash)`), timeout-exemptions.yml → Get-TimeoutSeconds, Get-TimeoutSeconds → the frame (`-Executable · -Budget`) |

Five edges are straight; the one from TimeoutsConfig to Get-TimeoutSeconds turns once. None crosses another. The one count chip, `22` with
the file's olive rim, sits under timeouts.yml.

## Legend

A full-width panel below the bands, in two columns, left to right:

| Swatch            | Phrase                         |
| ----------------- | ------------------------------ |
| slate rounded box | code unit                      |
| olive page        | file                           |
| neutral rhombus   | gate                           |
| thin arrow        | flow: feeds                    |
| light disc `1`    | marker: a Walkthrough step     |
| olive-rimmed `22` | count chip: executable entries |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-AUTO-DEFAULT and ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
