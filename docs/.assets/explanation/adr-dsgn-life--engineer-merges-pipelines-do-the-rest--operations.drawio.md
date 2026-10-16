---
catzc:
  immutable:
    with_body_sha: "0dd9e7fae4ff"
    path: docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-life-engineer-merges-pipelines-do-the-rest-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md
      - docs/explanation/design/engineer-merges-pipelines-do-the-rest.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# An engineer runs the tests and merges; pipelines do the rest: the diagram described

```text
A 1572 x 600 diagram, read left to right along a top row, with failures in a band below.
Glyphs: 3 runners (slate), 1 gate, 1 ADR-only runner, 3 failures; 3 flow, 2 ADR-only, 3 failure-path edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/engineer-merges-pipelines-do-the-rest.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two bands stand side by side on top, labelled
PERSON RUNS and PIPELINE RUNS, and one full-width band below, labelled ON FAILURE. Two span bars run above: CI over the gate and the first
pipeline runner, and CD over the dashed runner and the wide runner. The top row reads left to right; three red failure glyphs sit in the
bottom band, each straight below what raises it. The eye lands first on the wide slate runner at the right of the top row, then on the three
red boxes.

## Reading path

1. Marker 1, PERSON RUNS band: the runner `Test-Automation`.
2. Marker 2: the gate `merge the PR`.
3. Markers 3, 4 and 5, PIPELINE RUNS band, left to right: the runner `post-commit CI`, the dashed runner `L3 run`, and the wide runner
   `cd-shared · cd-<customer>`. A line also leaves the gate's top, runs right above the row, and drops into the wide runner.
4. Markers 6, 7 and 8, ON FAILURE band, left to right: the failures `PR blocked`, `red CI run` and `stage failed`.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| runner                | 3     | `Test-Automation` (PERSON RUNS), `post-commit CI` and `cd-shared · cd-<customer>` (PIPELINE RUNS) |
| gate                  | 1     | `merge the PR`, PERSON RUNS, grey rhombus with a 3 px rim                                         |
| ADR-only              | 1     | `L3 run`, a white dashed runner, PIPELINE RUNS                                                    |
| failure               | 3     | `PR blocked`, `red CI run`, `stage failed`, ON FAILURE band                                       |

The runners are slate with white names; the gate is neutral grey.

## Edges

| Edge kind    | Count | From → to                                                                                          |
| ------------ | ----- | -------------------------------------------------------------------------------------------------- |
| flow         | 3     | Test-Automation → merge the PR → post-commit CI; merge the PR → cd-shared · cd-\<customer\>        |
| ADR-only     | 2     | post-commit CI → L3 run → cd-shared · cd-\<customer\>                                              |
| failure path | 3     | merge the PR → PR blocked; post-commit CI → red CI run; cd-shared · cd-\<customer\> → stage failed |

The flow edge from the gate to the wide runner is drawn in three straight segments: up from the gate's top, right above the row, and down
into the wide runner. The other edges are straight; the failure paths drop straight down. None crosses another. No chips appear.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                         | Phrase                        |
| ------------------------------ | ----------------------------- |
| slate pill                     | runner                        |
| grey rhombus, 3 px rim         | gate                          |
| red rounded box                | failure: what the person sees |
| white dashed box, dashed arrow | ADR-only (no code)            |
| thin arrow                     | flow: runs next               |
| red arrow                      | failure path                  |
| dark disc `1`                  | marker: a Walkthrough step    |
| span bar                       | span bar: stages over bands   |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-DSGN-LIFE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.grid.md),
[tree](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.tree.md) and [value-chain map](adr-dsgn-life--engineer-merges-pipelines-do-the-rest--operations.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-DSGN-LIFE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
