# Merging to main is what deploys; there is no run that deploys a topic: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 2 commits, 3 runners (slate), 1 environment, 1 ADR-only; 5 flow edges, 1 ADR-only edge; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-dsgn-life--merging-to-main-is-what-deploys--operations.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](merging-to-main-is-what-deploys.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING. It holds seven glyphs: two commits, three runners, one
environment and one ADR-only glyph. The top row runs from the brown commit to the grey one, then to a runner and a wide environment hexagon.
From the brown commit a vertical line drops through the TOPIC band and branches right three times: two solid branches to runners and a
dashed branch to the ADR-only pill. Two span bars sit inside the bands: CI over the first branch's runner, and CD over the AFTER LANDING
row. Six markers number the reading order.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled push topic, open PR.
2. Down the vertical line and right to marker 2, OUT-OF-BAND band: the runner ADO PR build, under the CI span bar.
3. Marker 3: the runner Release: Run workflow.
4. Down the dashed leg and right to marker 4: the dashed white pill, deploy topic.
5. Back to the top row, along the flow edge to marker 5, MAIN band: the grey commit, complete PR.
6. Right to marker 6, AFTER LANDING band, under the CD span bar: the runner ADO CD run, then the environment `<Customer>-<env>[-<slot>]`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                            |
| --------------------- | ----- | -------------------------------------------------------------------------------- |
| commit                | 2     | brown push topic, open PR (TOPIC), grey complete PR (MAIN)                       |
| runner                | 3     | ADO PR build and Release: Run workflow (OUT-OF-BAND), ADO CD run (AFTER LANDING) |
| environment           | 1     | `<Customer>-<env>[-<slot>]` (AFTER LANDING, top row), empty                      |
| ADR-only              | 1     | deploy topic (OUT-OF-BAND, bottom row), a dashed white pill                      |

Runners are slate pills with white names; the environment is neutral grey; the commits keep the locked commit palette.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                               |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | push topic, open PR → complete PR, complete PR → ADO CD run, ADO CD run → environment (top row); push topic, open PR → ADO PR build and → Release: Run workflow, both from a vertical trunk drawn as two leg cells with no arrowhead and two right legs with arrowheads |
| ADR-only  | 1     | push topic, open PR → deploy topic (a dashed down leg with no arrowhead from the trunk's lower bend point, then a dashed right leg with the arrowhead)                                                                                                                  |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                            |
| --------------------------------- | --------------------------------- |
| brown and grey discs              | commit (locked palette)           |
| slate pill                        | runner: a run you start or see    |
| grey hexagon                      | environment                       |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge |
| thin arrow                        | flow: starts a run                |
| dark disc `1`                     | marker: a Walkthrough step        |
| crossbar                          | span bar: stages over bands       |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-dsgn-life--merging-to-main-is-what-deploys--operations.grid.md),
[tree](../.assets/tree/adr-dsgn-life--merging-to-main-is-what-deploys--operations.tree.md) and
[value-chain map](../.assets/chain/adr-dsgn-life--merging-to-main-is-what-deploys--operations.chain.md), which hold the reason for every lit
cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
