---
catzc:
  immutable:
    with_body_sha: "6c08474e398d"
    repo_status: clean
    path: docs/explanation/flow/globs-module-owns-config-and-types.drawio.md
    folder: docs/explanation/flow
    name: globs-module-owns-config-and-types-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md
      - docs/explanation/flow/globs-module-owns-config-and-types.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Catzc.Base.Globs owns config, types and roles: the diagram described

```text
A 1572 x 560 diagram, read left to right through two bands.
Glyphs: 1 file (olive), 5 code units (slate), 1 runner (slate), 1 external tool (grey); 7 flow edges; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](globs-module-owns-config-and-types.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, a wide GLOBS MODULE band and a narrower EDGE band. It holds eight glyphs, one file, five code units, one runner and one
external tool, joined by seven straight horizontal edges, with six markers and a legend panel along the bottom. The eye lands first on the
tall code unit near the left, which spans all three rows.

## Reading path

1. Marker 1, GLOBS MODULE band, left: the file globs.yml, at mid-height.
2. Along its edge to marker 2: the tall code unit GlobsConfig → GlobSet.
3. Along three parallel edges to markers 3, 4 and 5, top to bottom: the code units Trigger projection, Change report and Protection
   identity.
4. Into the EDGE band: the runner Pipelines · workflows (top row), reached by an edge from Trigger projection, and the external tool git
   (middle row), whose edge points left into Change report.
5. Marker 6, EDGE band, bottom row: the code unit Test-Automation, reached by an edge from Protection identity.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                 |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | globs.yml (GLOBS MODULE band, left, middle row)                                                                                                       |
| code unit             | 5     | GlobsConfig → GlobSet (tall, all rows); Trigger projection, Change report, Protection identity (one per row); Test-Automation (EDGE band, bottom row) |
| runner                | 1     | Pipelines · workflows (EDGE band, top row)                                                                                                            |
| external tool         | 1     | git (EDGE band, middle row)                                                                                                                           |

The file is olive; the code units and the runner are slate, told apart by shape (the runner is a pill), all with white names. The external
tool is a grey square box.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                            |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 7     | globs.yml → GlobsConfig → GlobSet; GlobsConfig → GlobSet → each of the three role code units; Trigger projection → Pipelines · workflows; git → Change report; Protection identity → Test-Automation |

Every edge is straight and horizontal, and none crosses another. Only the middle edge in the EDGE band runs right to left.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                        |
| ----------------- | ----------------------------- |
| olive folded page | file                          |
| slate rounded box | code unit                     |
| slate pill        | runner                        |
| grey square box   | external tool                 |
| thin arrow        | flow: output read by the next |
| grey band         | band: module boundary         |
| dark disc `1`     | marker: a Walkthrough step    |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--globs-module-owns-config-and-types--architecture.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** ARCH, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
