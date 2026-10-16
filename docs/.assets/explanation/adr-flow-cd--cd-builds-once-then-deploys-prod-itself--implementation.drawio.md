---
catzc:
  immutable:
    with_body_sha: eb34fc4ffbe3
    path: docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-cd-builds-once-then-deploys-prod-itself-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png
      - docs/.assets/explanation/chain/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md
      - docs/.assets/explanation/grid/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md
      - docs/.assets/explanation/tree/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md
      - docs/explanation/flow/cd-builds-once-then-deploys-prod-itself.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The customer CD pipeline builds once, then deploys prod itself: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 runners (slate), 3 results, 2 environments; 10 flow edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/cd-builds-once-then-deploys-prod-itself.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled CI STAGE, DEPLOY STAGES and TARGETS. Two span bars sit above them: CD over the first two bands on the upper
row, CI over the first band on the lower row. It holds nine glyphs (four runners, three results and two environments), six markers, and a
legend panel along the bottom. The eye lands first on the tall slate capsule Build-Bicep at the far left.

## Reading path

1. Marker 1, CI STAGE: the runner Build-Bicep, a tall capsule.
2. Marker 2, CI STAGE: the first of three stacked results, foundation, then discovery and expedition below it.
3. Marker 3, DEPLOY STAGES: the runner Deploy_Foundation, the top of three stacked runners.
4. Marker 4, beside the edge from Deploy_Foundation down to Deploy_Discovery.
5. Marker 5, TARGETS: the environment nsub · dev · test.
6. Marker 6, TARGETS: the environment psub · prod.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                         |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| runner                | 4     | Build-Bicep (CI STAGE, tall), Deploy_Foundation, Deploy_Discovery, Deploy_Expedition (DEPLOY STAGES, stacked) |
| result                | 3     | foundation, discovery, expedition (CI STAGE, stacked)                                                         |
| environment           | 2     | nsub · dev · test (TARGETS, upper), psub · prod (TARGETS, lower)                                              |

The runners are slate with white names; the results are light green; the environments are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                       |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 10    | Build-Bicep → each of the three results; each result → the runner beside it; Deploy_Foundation → Deploy_Discovery → Deploy_Expedition; the DEPLOY STAGES band's right border → each environment |

Every edge is straight. Six run horizontally in three rows, two run vertically between the stacked deploy runners, and two leave the right
border of the DEPLOY STAGES band, one at the height of each environment. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| green rounded box | result                      |
| grey hexagon      | environment                 |
| solid arrow       | flow: next in code order    |
| span bar          | span bar: stages over bands |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](grid/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.grid.md),
[tree](tree/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.tree.md) and [value-chain map](chain/adr-flow-cd--cd-builds-once-then-deploys-prod-itself--implementation.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
