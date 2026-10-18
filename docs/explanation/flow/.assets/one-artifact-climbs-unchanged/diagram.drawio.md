# One artifact is built once and climbs to production unchanged: the diagram described

```text
A 1572 x 600 diagram, read left to right through two bands.
Glyphs: 1 runner (slate), 1 result, 2 environments, 1 ADR-only gate; 3 flow and 2 ADR-only edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](diagram.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../one-artifact-climbs-unchanged.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two
bands, labelled AUTOMATED (wider, left) and GOVERNED (right). Three span bars sit above them: CD and DEPLOY on the upper row, CI on the
lower row. It holds five glyphs (one runner, one result, two environments and one gate), six markers, and a legend panel along the bottom.
The eye lands first on the slate runner and the green result at the left of the AUTOMATED band.

## Reading path

1. Marker 1, AUTOMATED: the runner build & verify.
2. Marker 2, AUTOMATED: the result tagged artifact.
3. Marker 3, AUTOMATED: the environment non-prod.
4. Marker 4, GOVERNED: the gate `human gate`, white with a thin dashed rim, inside a dashed frame.
5. Marker 5, GOVERNED: the environment production.
6. Marker 6, below the bands: beside the lane from tagged artifact to production.

## Glyphs

| Glyph (legend phrase)    | Count | Where                                                     |
| ------------------------ | ----- | --------------------------------------------------------- |
| runner                   | 1     | build & verify (AUTOMATED, left)                          |
| result                   | 1     | tagged artifact (AUTOMATED, centre)                       |
| environment              | 2     | non-prod (AUTOMATED, right), production (GOVERNED, right) |
| gate, ADR-only (no code) | 1     | `human gate` (GOVERNED, left; dashed frame)               |

The runner is slate with a white name; the result is light green; the environments are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                             |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | build & verify → tagged artifact, tagged artifact → non-prod, tagged artifact → production (down, along the lane, up) |
| ADR-only  | 2     | non-prod → `human gate`, `human gate` → production                                                                    |

The top row is one straight horizontal line of edges. The lane leaves the bottom of tagged artifact, runs right below both bands, and rises
into the bottom of production; it is drawn as three straight segments. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                                   |
| ------------------------- | ---------------------------------------- |
| slate pill                | runner                                   |
| green rounded box         | result                                   |
| grey hexagon              | environment                              |
| white rhombus, dashed rim | gate, ADR-only (no code)                 |
| solid arrow               | flow: the artifact moves on              |
| dashed arrow              | ADR-only (no code): dashed line or frame |
| span bar                  | span bar: stages over bands              |
| dark disc `1`             | marker: a Walkthrough step               |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](grid.md),
[tree](tree.md) and
[value-chain map](chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
