# Deploying a topic commit is not integrating it: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 1 gate, 1 environment; 3 flow edges, 1 ADR-only edge; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](deploying-is-not-integrating.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds six glyphs: four commits, one gate and one environment. A straight flow line runs across the top row from the brown
commit to the yellow one; a dashed edge drops from the brown commit and runs right into the environment. Five markers number the reading
order, and a legend panel runs along the bottom.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic commit.
2. Marker 2, beside the dashed edge's down leg in the TOPIC band; the edge then turns right into the OUT-OF-BAND band.
3. Marker 3, OUT-OF-BAND band: the environment hexagon, with a small brown commit inside, above its name.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main.
5. Right to marker 5, AFTER LANDING band: the gate BVT, then on to the yellow commit BVT-verified.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| commit                | 4     | brown topic commit (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 1     | BVT (AFTER LANDING, top row), 3 px rim                                                                                         |
| environment           | 1     | environment (OUT-OF-BAND, middle)                                                                                              |

The commits keep the locked commit palette; the gate and the environment are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                  |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | topic commit → main, main → BVT, BVT → BVT-verified                                                                                                        |
| ADR-only  | 1     | topic commit → environment (drawn as two cells: a dashed down leg with no arrowhead to a bend point, then a dashed right leg with the arrowhead; marker 2) |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                        | Phrase                           |
| ----------------------------- | -------------------------------- |
| brown, grey and yellow discs  | commit (locked palette)          |
| grey rhombus with a thick rim | gate                             |
| grey hexagon                  | environment: its occupant inside |
| dashed arrow                  | ADR-only (no code)               |
| thin arrow                    | flow: lands, then climbs         |
| dark disc `1`                 | marker: a Walkthrough step       |
| crossbar                      | span bar: stages over bands      |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE and ADR-DSGN-VISUAL): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md),
[tree](../.assets/tree/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** META, with "Supports ADR-DSGN-LIFE and ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
