---
catzc:
  immutable:
    with_body_sha: "640c510e3ae1"
    path: docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-every-deploy-stage-is-main-only-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md
      - docs/explanation/design/every-deploy-stage-is-main-only.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every Deploy stage runs only from main: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 2 commits, 3 runners (slate), 2 gates, 1 ADR-only; 6 flow edges, 1 ADR-only edge; 1 count chip; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/every-deploy-stage-is-main-only.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING. It holds eight glyphs: two commits, three runners, two
gates and one ADR-only glyph. The top row runs from the brown commit to the grey one and on through a runner, a gate and a second runner.
From the brown commit a vertical line drops through the TOPIC band and branches right twice: a solid branch to a runner and a gate, and a
dashed branch to the ADR-only pill. Two span bars sit inside the bands: CI over the middle-row runner and gate, and CD over the AFTER
LANDING row. Seven markers number the reading order.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic branch.
2. Down the vertical line and right to marker 2, OUT-OF-BAND band: the runner stage: CI, under the CI span bar.
3. Right to marker 3: the gate main only. No edge leaves it.
4. Down the dashed leg and right to marker 4: the dashed white pill, out-of-band deploy.
5. Back to the top row, along the flow edge to marker 5, MAIN band: the grey commit, main.
6. Right to marker 6, AFTER LANDING band, under the CD span bar: the runner stage: CI, then the gate main only.
7. Marker 7: the runner Deploy\_\* stages, with the count chip 6 on its top-right corner.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                         |
| --------------------- | ----- | --------------------------------------------------------------------------------------------- |
| commit                | 2     | brown topic branch (TOPIC), grey main (MAIN)                                                  |
| runner                | 3     | stage: CI (OUT-OF-BAND, middle row), stage: CI and Deploy\_\* stages (AFTER LANDING, top row) |
| gate                  | 2     | main only (OUT-OF-BAND, middle row), main only (AFTER LANDING, top row); both with a 3 px rim |
| ADR-only              | 1     | out-of-band deploy (OUT-OF-BAND, bottom row), a dashed white pill                             |

Runners are slate pills with white names; the gates are neutral grey; the commits keep the locked commit palette. One count chip, 5, a white
pill with a slate rim, sits on the top-right corner of Deploy\_\* stages.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                                                                                                               |
| --------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | topic branch → main, main → stage: CI, stage: CI → main only, main only → Deploy\_\* stages (top row); topic branch → stage: CI (middle row; drawn as two cells, a down leg with no arrowhead to a bend point, then a right leg with the arrowhead); stage: CI → main only (middle row) |
| ADR-only  | 1     | topic branch → out-of-band deploy (drawn as two cells from the middle-row bend point: a dashed down leg with no arrowhead, then a dashed right leg with the arrowhead)                                                                                                                  |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                                 |
| --------------------------------- | -------------------------------------- |
| brown and grey discs              | commit (locked palette)                |
| slate pill                        | runner: a pipeline stage               |
| grey rhombus with a thick rim     | gate: Deploy\_\* condition             |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge      |
| thin arrow                        | flow: starts or runs next              |
| white chip `6` with a slate rim   | count chip: stages that carry the gate |
| dark disc `1`                     | marker: a Walkthrough step             |
| crossbar                          | span bar: stages over bands            |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.grid.md),
[tree](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.tree.md) and [value-chain map](adr-dsgn-life--every-deploy-stage-is-main-only--implementation.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
