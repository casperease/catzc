---
catzc:
  immutable:
    with_body_sha: "6eb214b978f7"
    repo_status: clean
    path: docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.drawio.md
    folder: docs/explanation/flow
    name: pipeline-kinds-keyed-by-one-artifact-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md
      - docs/explanation/flow/pipeline-kinds-keyed-by-one-artifact.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# CI, CD and DEPLOY keyed together by one artifact: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 1 runner (slate), 1 result, 4 environments, 2 ADR-only gates; 3 flow and 5 ADR-only edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](pipeline-kinds-keyed-by-one-artifact.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. Three span bars
sit at the top: CD and DEPLOY on the upper row, CI on the lower row. Below them are three bands side by side, labelled CD, DEPLOY-NON-PROD
and DEPLOY-PROD, with a gap between each pair. It holds eight glyphs (one runner, one result, four environments and two gates), eight
markers, and a legend panel along the bottom. The eye lands first on the slate runner and the green result at the left of the CD band.

## Reading path

1. Marker 1, CD band: the runner CI component.
2. Marker 2, CD band: the result tagged artifact.
3. Marker 3, CD band: the environment main-uat.
4. Marker 4, in the gap after the CD band: the gate RC, thin dashed rim, inside a dashed frame.
5. Marker 5, DEPLOY-NON-PROD band: the environment release-uat, white and dashed, inside a dashed frame.
6. Marker 6, in the next gap: the gate RBC, thin dashed rim, inside a dashed frame.
7. Marker 7, DEPLOY-PROD band: the environment pre-prod, then the environment production to its right.
8. Marker 8, below the bands: beside the lane that runs from tagged artifact to production.

## Glyphs

| Glyph (legend phrase)    | Count | Where                                                                                                         |
| ------------------------ | ----- | ------------------------------------------------------------------------------------------------------------- |
| runner                   | 1     | CI component (CD band, left)                                                                                  |
| result                   | 1     | tagged artifact (CD band, centre)                                                                             |
| environment              | 4     | main-uat (CD band, right), release-uat (DEPLOY-NON-PROD, dashed frame), pre-prod and production (DEPLOY-PROD) |
| gate, ADR-only (no code) | 2     | RC (gap after CD), RBC (gap after DEPLOY-NON-PROD); both in a dashed frame                                    |

The runner is slate with a white name; the result is light green; the environments are neutral grey, except release-uat, which is white with
a dashed rim.

## Edges

| Edge kind | Count | From → to                                                                                                           |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | CI component → tagged artifact, tagged artifact → main-uat, tagged artifact → production (down, along the lane, up) |
| ADR-only  | 5     | main-uat → RC, RC → release-uat, release-uat → RBC, RBC → pre-prod, pre-prod → production                           |

The top row is one straight horizontal line of edges. The lane leaves the bottom of tagged artifact, runs right below the three bands, and
rises into the bottom of production; it is drawn as three straight segments. Nothing crosses.

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
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
