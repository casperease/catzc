---
catzc:
  immutable:
    with_body_sha: "9f107ed80844"
    path: docs/.assets/explanation/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-detect-two-variables-read-in-one-place-implementation-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.chain.md
      - docs/.assets/explanation/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.drawio.png
      - docs/.assets/explanation/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.grid.md
      - docs/.assets/explanation/adr-flow-cd-detect--two-variables-read-in-one-place--implementation.tree.md
      - docs/explanation/flow/two-variables-read-in-one-place.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Two variables read in one place: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands, then left to right along a fourth.
Glyphs: 2 runners (slate), 6 code units (slate), 1 file (olive), 1 gate (neutral); 5 flow edges; 1 frame; 1 count chip; 10 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-flow-cd-detect--two-variables-read-in-one-place--implementation.drawio.png) draws, in the vocabulary
of the diagram glyphs; what it means is in [the article](../../explanation/flow/two-variables-read-in-one-place.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands on the top row, `PLATFORM`, `LOADER` and `CONSUMERS`, then left to right again along a full-width band below, `ANALYZER`. It holds ten
glyphs: two runners, six code units, one file and one gate, joined by five flow edges. Four of the code units sit in a two-by-two frame that
carries a count chip at its top-right corner, two names sit beside the edges that leave the runners, and ten markers number the glyphs. A
legend panel runs along the bottom. The eye lands first on the frame of four code units, the largest shape on the drawing.

## Reading path

1. Markers 1 and 2, `PLATFORM` band: the runners Azure DevOps agent and GitHub Actions runner, stacked, with the names `TF_BUILD` and
   `GITHUB_ACTIONS` beside the edges that leave them.
2. Along the two converging flow edges to marker 3, `LOADER` band: the code unit Test-IsRunningInPipeline.
3. Along the flow edge into the frame in the `CONSUMERS` band: markers 4 and 5 on the top row, Get-OutputRoot and Get-RunEnvironment, then
   markers 6 and 7 on the bottom row, Get-GlobSetChangeRange and Set-AdoPipelineVariable; the count chip `24` on the frame's top-right
   corner.
4. Down to the `ANALYZER` band and left to right: marker 8, the file PSScript…Settings.psd1; along a flow edge to marker 9, the code unit
   CatzcRules.psm1; along a flow edge to marker 10, the gate Measure-…PipelineDetection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                                      |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| runner                | 2     | Azure DevOps agent, GitHub Actions runner (`PLATFORM` band)                                                                                                                |
| code unit             | 6     | Test-IsRunningInPipeline (`LOADER`); Get-OutputRoot, Get-RunEnvironment, Get-GlobSetChangeRange, Set-AdoPipelineVariable (`CONSUMERS` frame); CatzcRules.psm1 (`ANALYZER`) |
| file                  | 1     | PSScript…Settings.psd1 (`ANALYZER` band, left)                                                                                                                             |
| gate                  | 1     | Measure-…PipelineDetection (`ANALYZER` band, right)                                                                                                                        |

Runners and code units are slate with light names, the file is an olive page with a folded corner, and the gate is a neutral rhombus with a
thick light rim. The frame is a thin dark-rimmed rounded rectangle with no fill, and its count chip has a slate rim.

## Edges

| Edge kind                 | Count | From → to                                                                                                                                                                                                                                                                                   |
| ------------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds the next step | 5     | Azure DevOps agent → Test-IsRunningInPipeline (`TF_BUILD` beside it); GitHub Actions runner → Test-IsRunningInPipeline (`GITHUB_ACTIONS` beside it); Test-IsRunningInPipeline → the consumers frame; PSScript…Settings.psd1 → CatzcRules.psm1; CatzcRules.psm1 → Measure-…PipelineDetection |

The two edges from the runners converge on the detector's left side; the other three are horizontal. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                              |
| ---------------------- | ----------------------------------- |
| slate pill             | runner                              |
| slate rounded box      | code unit                           |
| olive folded page      | file                                |
| neutral rhombus        | gate                                |
| thin arrow             | flow: feeds the next step           |
| slate-rimmed chip `24` | count chip: callers of the detector |
| light disc `1`         | marker: a Walkthrough step          |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-DETECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-flow-cd-detect--two-variables-read-in-one-place--implementation.grid.md),
[tree](adr-flow-cd-detect--two-variables-read-in-one-place--implementation.tree.md) and [value-chain map](adr-flow-cd-detect--two-variables-read-in-one-place--implementation.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-DETECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
