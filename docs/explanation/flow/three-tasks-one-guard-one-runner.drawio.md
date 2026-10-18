# Three tasks share one guard, and one runner imports, traps, sanitizes and invokes: the diagram described

```text
A 1572 x 600 diagram, read left to right through two bands side by side.
Glyphs: 2 files (olive), 1 gate, 1 failure, 4 code units (slate); 7 flow edges, 1 failure path; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](three-tasks-one-guard-one-runner.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through two bands
side by side, TEMPLATE and RUNNER. It holds eight glyphs (two files, one gate, one failure and four code units) joined by eight edges, with
eight markers and a legend panel below the bands. The eye lands first on the grey rhombus between the two olive pages and the row of slate
boxes, with the red box beneath it.

## Reading path

1. Marker 1, TEMPLATE band: the file ci-automation.yaml, at the left edge.
2. Right to marker 2, the file invoke-automation.yaml.
3. Right along the edge with the fraction chip 3/3 to marker 3, the gate inline guard.
4. Down the failure path to marker 4, the failure throw.
5. Right from the gate into the RUNNER band: markers 5 to 8, the code units importer.ps1, trap, sanitize and Invoke-Command.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                      |
| --------------------- | ----- | ---------------------------------------------------------- |
| file                  | 2     | ci-automation.yaml, invoke-automation.yaml (TEMPLATE band) |
| gate                  | 1     | inline guard (TEMPLATE band, right)                        |
| failure               | 1     | throw (TEMPLATE band, under the gate)                      |
| code unit             | 4     | importer.ps1, trap, sanitize, Invoke-Command (RUNNER band) |

Files are olive pages and code units slate boxes, both with white names; the gate is a grey rhombus with a 3 px rim.

## Edges

| Edge kind    | Count | From → to                                                                                                    |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------ |
| flow         | 7     | ci-automation.yaml → invoke-automation.yaml → inline guard → importer.ps1 → trap → sanitize → Invoke-Command |
| failure path | 1     | inline guard → throw                                                                                         |

The flow edges are horizontal along one row; the failure path drops straight down from the gate's bottom vertex. None crosses another. One
fraction chip, 3/3, sits just above the edge into the gate.

## Legend

A full-width panel below the bands, in four columns, left to right:

| Swatch                  | Phrase                                    |
| ----------------------- | ----------------------------------------- |
| olive page              | file                                      |
| grey rhombus, thick rim | gate                                      |
| slate rounded box       | code unit                                 |
| red rounded box         | failure                                   |
| thin grey arrow         | flow: next in code order                  |
| thin red arrow          | failure path                              |
| bold `3/3`              | fraction chip: tasks that carry the guard |
| dark disc `1`           | marker: a Walkthrough step                |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-RUNNER): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/pwsh/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/pwsh/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/pwsh/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer with
minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.grid.md),
[tree](../.assets/tree/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-runner--three-tasks-one-guard-one-runner--implementation.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** IMPL, with "Supports ADR-FLOW-CD-RUNNER" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
