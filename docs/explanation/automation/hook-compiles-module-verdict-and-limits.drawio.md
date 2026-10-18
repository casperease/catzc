# The hook compiles the module's own verdict and limit types, so the agent side and the pwsh side agree: the diagram described

```text
A 1572 x 690 diagram, read top to bottom through three bands.
Glyphs: 1 external tool (neutral), 5 code units (slate), 1 file (olive); 6 flow edges; 7 markers; one frame.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.drawio.png) draws, in
the vocabulary of the diagram glyphs; what it means is in [the article](hook-compiles-module-verdict-and-limits.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `CLAUDE CODE`, `HOOK` and `CATZC.BASE.TIMEOUTS`. It holds seven glyphs, one external tool, five code units and
one file, joined by six flow edges, with seven markers and a legend panel along the bottom. Inside the bottom band a thin frame groups three
code units side by side. The eye lands first on the vertical line of three glyphs down the centre, ending on the frame.

## Reading path

1. Marker 1, `CLAUDE CODE` band: the external tool Bash tool, centred.
2. Down the flow edge to marker 2, `HOOK` band: the code unit Assert-BashTimeout, centred.
3. Down the flow edge into the frame, `CATZC.BASE.TIMEOUTS` band: marker 3, the code unit BashSafeguard in the middle of the frame, with
   flow edges left to marker 5, TimeoutsConfig, and right to marker 4, BoundedCommand.
4. Down the flow edge from TimeoutsConfig to marker 6: the file timeouts.yml, below the frame.
5. Marker 7, left of the frame: the code unit Get-TimeoutSeconds, with a flow edge into TimeoutsConfig.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                  |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------- |
| external tool         | 1     | Bash tool (`CLAUDE CODE` band, centre)                                                                                                 |
| code unit             | 5     | Assert-BashTimeout (`HOOK` band); TimeoutsConfig, BashSafeguard, BoundedCommand (in the frame); Get-TimeoutSeconds (left of the frame) |
| file                  | 1     | timeouts.yml (`CATZC.BASE.TIMEOUTS` band, below TimeoutsConfig)                                                                        |

Code units are slate and the file olive, both with light names; the external tool is a neutral square box, dark with a light rim. The frame
has no fill and a thin band-coloured rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                          |
| --------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | Bash tool → Assert-BashTimeout, Assert-BashTimeout → the frame, BashSafeguard → TimeoutsConfig, BashSafeguard → BoundedCommand, Get-TimeoutSeconds → TimeoutsConfig, TimeoutsConfig → timeouts.yml |

Every edge is straight, three vertical and three horizontal, and none crosses another. No edge carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| neutral square    | external tool              |
| slate rounded box | code unit                  |
| olive page        | file                       |
| light arrow       | flow: depends on           |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-FAILFAST): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.grid.md),
[tree](../.assets/tree/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-auto-failfast--hook-compiles-module-verdict-and-limits--architecture.chain.md), which hold the reason
for every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-AUTO-FAILFAST" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
