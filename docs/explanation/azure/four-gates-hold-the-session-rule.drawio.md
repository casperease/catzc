# Four gates hold the session rule; the customer and the name hold by construction: the diagram described

```text
A 1572 x 640 diagram, read left to right through two bands, with a third band below.
Glyphs: 4 gates (neutral), 2 code units (slate), 1 failure; 5 flow edges, 4 failure paths; 6 rule chips, 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-az-datamod--four-gates-hold-the-session-rule--governance.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](four-gates-hold-the-session-rule.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
on one row, `TARGET` and `CONFIG + NAMES`, with a full-width `OUTCOME` band below them. The upper row holds four gates and two code units in
one line, joined by five flow edges; four failure paths drop from the gates into one wide failure in the outcome band. Six rule chips sit at
the top-right corner of the six upper glyphs, and seven markers and a legend panel complete the drawing. The eye lands first on the wide red
failure spanning most of the outcome band.

## Reading path

1. Marker 1, target band: the gate assert given in a pipeline, rule chip `D7`.
2. Right to marker 2: the gate subscription declared, chip `D7`; right to marker 3: the gate session matches the assert, chip `D7`.
3. Right across the band gap to marker 4, config band: the code unit customer from the session, chip `D4`.
4. Right to marker 5: the gate serves the env, chip `D7`; right to marker 6: the code unit RG name derived, chip `D5 N8`.
5. Down any failure path to marker 7, outcome band: the wide failure throw.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                     |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 4     | assert given in a pipeline, subscription declared, session matches the assert (target band); serves the env (config band) |
| code unit             | 2     | customer from the session, RG name derived (config band)                                                                  |
| failure               | 1     | throw (outcome band, full width)                                                                                          |

Gates are neutral, code units slate and the failure red.

## Edges

| Edge kind       | Count | From → to                                                                                                                                      |
| --------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: runs next | 5     | assert given in a pipeline → subscription declared → session matches the assert → customer from the session → serves the env → RG name derived |
| failure path    | 4     | each of the four gates → throw                                                                                                                 |

The five flow edges are horizontal on one line; the four failure paths are vertical and end on the top edge of the failure, each below its
gate.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                           |
| ----------------- | ------------------------------------------------ |
| neutral rhombus   | gate                                             |
| slate rounded box | code unit                                        |
| red rounded box   | failure                                          |
| thin arrow        | flow: runs next                                  |
| red arrow         | failure path                                     |
| light chip `D7`   | rule chip: D = ADR-AZ-DATAMOD, N = ADR-AZ-NAMING |
| light disc `1`    | marker: a Walkthrough step                       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AZ-DATAMOD and ADR-AZ-NAMING): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-az-datamod--four-gates-hold-the-session-rule--governance.grid.md),
[tree](../.assets/tree/adr-az-datamod--four-gates-hold-the-session-rule--governance.tree.md) and
[value-chain map](../.assets/chain/adr-az-datamod--four-gates-hold-the-session-rule--governance.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** GOV, with "Supports ADR-AZ-DATAMOD and ADR-AZ-NAMING" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
