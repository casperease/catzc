# A merge to main runs the CD pipeline all the way to prod, with no approval: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands, with a failures band below.
Glyphs: 1 actor, 2 runners (slate), 2 environments, 2 failures; 4 flow edges and 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd--a-merge-runs-cd-to-prod--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](a-merge-runs-cd-to-prod.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands on the upper row, labelled TRIGGER, CI STAGE, DEPLOY STAGES and TARGETS, with a FAILURES band below the last two. Two span bars sit
above: CD over CI STAGE and DEPLOY STAGES on the upper row, CI over CI STAGE on the lower row. It holds seven glyphs (one actor, two
runners, two environments and two failures), seven markers, and a legend panel along the bottom. The eye lands first on the large slate
capsule `Deploy_*` stages in the middle.

## Reading path

1. Marker 1, TRIGGER: the actor developer.
2. Marker 2, CI STAGE: the runner Build-Bicep.
3. Marker 3, beside the edge from Build-Bicep into `Deploy_*` stages.
4. Marker 4, TARGETS: the environment nsub · dev · test.
5. Marker 5, TARGETS: the environment psub · prod.
6. Marker 6, FAILURES: the failure Deploy-Bicep.
7. Marker 7, FAILURES: the failure Get-BicepDeploymentContext.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                       |
| --------------------- | ----- | --------------------------------------------------------------------------- |
| actor                 | 1     | developer (TRIGGER)                                                         |
| runner                | 2     | Build-Bicep (CI STAGE), `Deploy_*` stages (DEPLOY STAGES, tall capsule)     |
| environment           | 2     | nsub · dev · test (TARGETS, upper), psub · prod (TARGETS, lower)            |
| failure               | 2     | Deploy-Bicep (FAILURES, left), Get-BicepDeploymentContext (FAILURES, right) |

The runners are slate with white names; the actor is a white circle; the environments are neutral grey; the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                                                            |
| ------------ | ----- | -------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | developer → Build-Bicep → `Deploy_*` stages; `Deploy_*` stages → each environment                                    |
| failure path | 2     | `Deploy_*` stages → Deploy-Bicep (straight down); `Deploy_*` stages → Get-BicepDeploymentContext (down, right, down) |

The flow edges are straight and horizontal. The second failure path is drawn as three straight segments. Nothing crosses.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch           | Phrase                      |
| ---------------- | --------------------------- |
| white circle     | actor                       |
| slate pill       | runner                      |
| grey hexagon     | environment                 |
| red rounded box  | failure                     |
| solid grey arrow | flow: what runs next        |
| solid red arrow  | failure path                |
| span bar         | span bar: stages over bands |
| dark disc `1`    | marker: a Walkthrough step  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd--a-merge-runs-cd-to-prod--operations.grid.md),
[tree](../.assets/tree/adr-flow-cd--a-merge-runs-cd-to-prod--operations.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd--a-merge-runs-cd-to-prod--operations.chain.md), which hold the reason for every lit cell or
group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
