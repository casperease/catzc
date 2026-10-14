# docs/.assets/explanation/adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.md

`CI, CD and DEPLOY keyed together by one artifact: the diagram described`

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 1 runner (slate), 1 result, 4 environments, 2 ADR-only gates; 4 flow and 5 ADR-only edges; 8 markers.
Sidebar: axis minimap (main cell PIPE x DEPLOY), tree minimap, lens badge ARCH, map key.
```

This describes what the [diagram](adr-flow-cd--pipeline-kinds-keyed-by-one-artifact--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/pipeline-kinds-keyed-by-one-artifact.md).

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
8. Marker 8, below the bands: beside the lane that runs from tagged artifact to pre-prod and production.

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

| Edge kind | Count | From → to                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 4     | CI component → tagged artifact, tagged artifact → main-uat, tagged artifact → production (down, along the lane, up), lane → pre-prod |
| ADR-only  | 5     | main-uat → RC, RC → release-uat, release-uat → RBC, RBC → pre-prod, pre-prod → production                                            |

The top row is one straight horizontal line of edges. The lane leaves the bottom of tagged artifact, runs right below the three bands, and
rises into the bottoms of pre-prod and production; it is drawn as four straight segments. Nothing crosses.

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

- **Axis minimap:** the main cell is PIPE × DEPLOY, framed and filled in the DEPLOY blue with the you-are-here dot. No other cell is
  touched. The PIPE and DEPLOY axis labels carry a blue tick.
- **Tree minimap:** two lit tiles, labelled adr/flow and pipelines.
- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD" beneath it.
- **Map key:** three swatches, for this slide's cell, a touched cell, and a lit file.
