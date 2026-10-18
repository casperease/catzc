---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/flow/the-loader-holds-the-one-detector.drawio.md
    folder: docs/explanation/flow
    name: the-loader-holds-the-one-detector-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.tree.md
      - docs/explanation/flow/the-loader-holds-the-one-detector.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# The detector lives in the loader, which both run modes import first and keep loaded: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands, then down to two more.
Glyphs: 2 runners (slate), 4 code units (slate), 1 named set (mauve), 1 gate (neutral); 5 flow edges; 1 frame; 1 count chip; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](the-loader-holds-the-one-detector.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands on the top row, `PLATFORM`, `LOADER` and `CALLERS`, then down into two bands on a second row, `HOOK` under `PLATFORM` and
`ENFORCEMENT` under the rest. It holds eight glyphs: two runners, four code units, one named set and one gate, joined by five flow edges.
Three of the callers sit inside a frame, the named set carries a count chip, and eight markers number the glyphs. A legend panel runs along
the bottom. The eye lands first on the code unit in the `LOADER` band, alone in the middle of the row.

## Reading path

1. Markers 1 and 2, `PLATFORM` band: the runners Azure DevOps agent and GitHub Actions runner, stacked.
2. Along the two converging flow edges to marker 3, `LOADER` band: the code unit Test-IsRunningInPipeline.
3. Along the flow edge into the frame in the `CALLERS` band: markers 4, 5 and 6, top to bottom, the code units Catzc.Internal.Bootstrap and
   Catzc.Internal.Builder and the named set Catzc modules with its count chip `22`.
4. Down the flow edge from the frame's lower edge to marker 7, `ENFORCEMENT` band: the gate Measure-…PipelineDetection.
5. Back to the left: down the flow edge from the `PLATFORM` band's lower edge to marker 8, `HOOK` band: the code unit Assert-BashTimeout.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| runner                | 2     | Azure DevOps agent, GitHub Actions runner (`PLATFORM` band)                                                                             |
| code unit             | 4     | Test-IsRunningInPipeline (`LOADER`), Catzc.Internal.Bootstrap and Catzc.Internal.Builder (`CALLERS` frame), Assert-BashTimeout (`HOOK`) |
| named set             | 1     | Catzc modules (`CALLERS` frame, bottom), with the count chip `22` at its right                                                          |
| gate                  | 1     | Measure-…PipelineDetection (`ENFORCEMENT` band)                                                                                         |

Runners and code units are slate, the named set is mauve, all with light names; the gate is a neutral rhombus with a thick light rim. The
frame is a thin dark-rimmed rounded rectangle with no fill around the three callers.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                            |
| ------------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 5     | Azure DevOps agent → Test-IsRunningInPipeline; GitHub Actions runner → Test-IsRunningInPipeline; Test-IsRunningInPipeline → the callers frame; the callers frame → Measure-…PipelineDetection; the `PLATFORM` band's lower edge → Assert-BashTimeout |

The two edges from the runners converge on the detector's left side; the edge into the frame is horizontal; the two downward edges are
vertical. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                                    |
| ---------------------- | ----------------------------------------- |
| slate pill             | runner                                    |
| slate rounded box      | code unit                                 |
| mauve rounded box      | named set                                 |
| neutral rhombus        | gate                                      |
| thin arrow             | flow: feeds the next step                 |
| mauve-rimmed chip `22` | count chip: module functions that call it |
| light disc `1`         | marker: a Walkthrough step                |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-DETECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-detect--the-loader-holds-the-one-detector--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-DETECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
