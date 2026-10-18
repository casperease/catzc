# The Azure DevOps step is named after its command, and its log echoes the command before it runs: the diagram described

```text
A 1572 x 620 diagram, read left to right along one row, with drops below it.
Glyphs: 1 runner (slate), 3 results, 2 failures, 1 actor; 3 flow edges, 2 failure paths, 1 ADR-only edge; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](the-step-is-named-after-its-command.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
RUN above and DEVELOPER below. It holds seven glyphs (one runner, three results, two failures and one actor) joined by six edges, with seven
markers and a legend panel along the bottom. The eye lands first on the row of green boxes across the PIPELINE RUN band, with two red boxes
beneath it.

## Reading path

1. Marker 1, PIPELINE RUN band: the runner pipeline step, at the left edge.
2. Down the failure path to marker 3, the failure guard throw.
3. Right from the runner to marker 2, the result step label.
4. Right to marker 4, the result Invoke-Automation [Mode], then marker 5, the result echoed command.
5. Down the failure path to marker 6, the failure Write-Exception.
6. From step label, down the dashed edge to marker 7, DEVELOPER band: the actor developer.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                             |
| --------------------- | ----- | --------------------------------------------------------------------------------- |
| runner                | 1     | pipeline step (PIPELINE RUN band, top left)                                       |
| result                | 3     | step label, Invoke-Automation [Mode], echoed command (PIPELINE RUN band, top row) |
| failure               | 2     | guard throw (under pipeline step), Write-Exception (under echoed command)         |
| actor                 | 1     | developer (DEVELOPER band, under step label)                                      |

The runner is a slate pill with a white name; results are green and failures red.

## Edges

| Edge kind    | Count | From → to                                                              |
| ------------ | ----- | ---------------------------------------------------------------------- |
| flow         | 3     | pipeline step → step label → Invoke-Automation [Mode] → echoed command |
| failure path | 2     | pipeline step → guard throw, echoed command → Write-Exception          |
| ADR-only     | 1     | step label → developer                                                 |

The flow edges are horizontal along the top row; the two failure paths and the dashed edge are vertical. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate pill        | runner                     |
| green rounded box | result                     |
| red rounded box   | failure                    |
| white circle      | actor                      |
| thin grey arrow   | flow: run order            |
| thin red arrow    | failure path               |
| dashed arrow      | ADR-only (no code)         |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-RUNNER): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.grid.md),
[tree](../.assets/tree/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-runner--the-step-is-named-after-its-command--operations.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
