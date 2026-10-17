---
catzc:
  immutable:
    with_body_sha: "00aebd64279c"
    repo_status: clean
    path: docs/explanation/flow/a-step-only-names-a-command.drawio.md
    folder: docs/explanation/flow
    name: a-step-only-names-a-command-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md
      - docs/explanation/flow/a-step-only-names-a-command.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# A pipeline step only names a command: the diagram described

```text
A 1572 x 600 diagram, read left to right along one row, then up from a lower band.
Glyphs: 2 runners, 2 code units (slate), 1 actor; 3 flow edges, 1 ADR-only edge; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-runner--a-step-only-names-a-command--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](a-step-only-names-a-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing has two full-width bands, PIPELINE
above and DEVELOPER below. It holds five glyphs (two runners, two code units and one actor) joined by four edges, with five markers and a
legend panel along the bottom. The eye lands first on the two slate pills at the left of the PIPELINE band.

## Reading path

1. Marker 1, PIPELINE band: the runner pipeline step, at the left edge.
2. Right to marker 2, the runner pipeline task.
3. Right to marker 3, the code unit runner.
4. A long edge right to marker 4, the code unit same command, at the right edge.
5. Marker 5, DEVELOPER band: the actor developer, whose dashed edge rises to same command.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                     |
| --------------------- | ----- | --------------------------------------------------------- |
| runner                | 2     | pipeline step, pipeline task (PIPELINE band, left)        |
| code unit             | 2     | runner (PIPELINE band, centre left), same command (right) |
| actor                 | 1     | developer (DEVELOPER band, under same command)            |

Runners and code units are slate with white names; the pill shape tells a runner from a code unit's rounded box.

## Edges

| Edge kind | Count | From → to                                                                    |
| --------- | ----- | ---------------------------------------------------------------------------- |
| flow      | 3     | pipeline step → pipeline task, pipeline task → runner, runner → same command |
| ADR-only  | 1     | developer → same command                                                     |

The flow edges are horizontal along one row; the ADR-only edge is vertical and dashed. None crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                      |
| ----------------- | --------------------------- |
| slate pill        | runner                      |
| slate rounded box | code unit                   |
| white circle      | actor                       |
| thin arrow        | flow: passes the command on |
| dashed arrow      | ADR-only (no code)          |
| dark disc `1`     | marker: a Walkthrough step  |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-RUNNER): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-runner--a-step-only-names-a-command--meta.grid.md),
[tree](../.assets/tree/adr-flow-cd-runner--a-step-only-names-a-command--meta.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-runner--a-step-only-names-a-command--meta.chain.md), which hold the reason for every lit cell or group
as of that build.

- **Lens badge:** META, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
