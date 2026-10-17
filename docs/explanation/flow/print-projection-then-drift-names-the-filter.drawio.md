---
catzc:
  immutable:
    with_body_sha: d21adfba4a51
    repo_status: clean
    path: docs/explanation/flow/print-projection-then-drift-names-the-filter.drawio.md
    folder: docs/explanation/flow
    name: print-projection-then-drift-names-the-filter-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.tree.md
      - docs/explanation/flow/print-projection-then-drift-names-the-filter.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Print the projection, then drift names the filter: the diagram described

```text
A 1572 x 720 diagram, read top to bottom through three bands.
Glyphs: 2 files (olive), 1 code unit (slate), 2 gates, 3 failures (red); 4 flow edges, 1 ADR-only edge, 3 failure paths; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](print-projection-then-drift-names-the-filter.md).

## At a glance

A 1572 × 720 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `COMPOSE`, `PROJECTION` and `CHECKED BY`, in two columns. It holds eight glyphs, two files, one code unit, two
gates and three failures, joined by four flow edges, one dashed ADR-only edge and three red failure paths, with eight markers and a legend
panel along the bottom. The eye lands first on the three red failures in the bottom band.

## Reading path

1. Marker 1, top band, left: the file globs.yml.
2. Down the vertical edge to marker 2, middle band, left: the code unit Get-GlobSetTrigger.
3. Right along the dashed edge to marker 3, middle band: the file pipelines/cd-apex.yaml.
4. Down from the code unit to marker 4, bottom band, left: the gate Test-GlobSetTriggerCoverage, and down its red edge to marker 5, the
   failure matches no ADO include.
5. Down from the pipeline file to marker 6, bottom band, centre: the gate Test-AdoPipelineTriggerGlob, which the one diagonal edge from the
   code unit also enters at its left vertex.
6. Right along two red edges to markers 7 and 8, stacked: the failures trigger drifted and pipeline file not found.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                       |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 2     | globs.yml (top band, left); pipelines/cd-apex.yaml (middle band, centre)                                                                    |
| code unit             | 1     | Get-GlobSetTrigger (middle band, left)                                                                                                      |
| gate                  | 2     | Test-GlobSetTriggerCoverage (bottom band, left); Test-AdoPipelineTriggerGlob (bottom band, centre)                                          |
| failure               | 3     | matches no ADO include (below the gate on the left); trigger drifted and pipeline file not found (right of the gate in the centre, stacked) |

Files are olive and the code unit slate, with light names; gates are neutral rhombi with a thick light rim; failures are the only red.

## Edges

| Edge kind          | Count | From → to                                                                                                                                                                                           |
| ------------------ | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow: feeds        | 4     | globs.yml → Get-GlobSetTrigger, Get-GlobSetTrigger → Test-GlobSetTriggerCoverage, pipelines/cd-apex.yaml → Test-AdoPipelineTriggerGlob, Get-GlobSetTrigger → Test-AdoPipelineTriggerGlob (diagonal) |
| ADR-only (no code) | 1     | Get-GlobSetTrigger → pipelines/cd-apex.yaml (dashed, horizontal)                                                                                                                                    |
| failure path       | 3     | Test-GlobSetTriggerCoverage → matches no ADO include, Test-AdoPipelineTriggerGlob → trigger drifted, Test-AdoPipelineTriggerGlob → pipeline file not found                                          |

The diagonal edge leaves the code unit's bottom-right corner and ends on the left vertex of the gate in the centre; it crosses no glyph and
no other edge.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                      |
| ----------------- | ------------------------------------------- |
| olive page        | file                                        |
| slate rounded box | code unit                                   |
| neutral rhombus   | gate                                        |
| red rounded box   | failure                                     |
| thin arrow        | flow: feeds                                 |
| dashed arrow      | ADR-only (no code): generated into the YAML |
| red arrow         | failure path                                |
| light disc `1`    | marker: a Walkthrough step                  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--print-projection-then-drift-names-the-filter--operations.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
