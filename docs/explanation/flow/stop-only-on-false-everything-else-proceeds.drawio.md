---
catzc:
  immutable:
    with_body_sha: a0bc850c00fe
    repo_status: clean
    path: docs/explanation/flow/stop-only-on-false-everything-else-proceeds.drawio.md
    folder: docs/explanation/flow
    name: stop-only-on-false-everything-else-proceeds-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.tree.md
      - docs/explanation/flow/stop-only-on-false-everything-else-proceeds.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Stop only on $false, everything else proceeds: the diagram described

```text
A 1572 x 640 diagram, read top to bottom through three bands.
Glyphs: 1 ADR-only, 1 code unit (slate), 3 results, 1 failure; 3 flow edges, 1 failure path, 1 ADR-only edge; 6 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.drawio.png) draws,
in the vocabulary of the diagram glyphs; what it means is in [the article](stop-only-on-false-everything-else-proceeds.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled `WHO RUNS IT`, `THE CALL` and `WHAT IT RETURNS AND PRINTS`. It holds six glyphs, an ADR-only, a code unit, three
results and a failure, joined by three flow edges, one failure path and one ADR-only edge, with six markers and a legend panel along the
bottom. The eye lands first on the wide slate code unit in the middle band.

## Reading path

1. Marker 1, `WHO RUNS IT` band: the ADR-only glyph a unit's pipeline stage, a dashed pill.
2. Down the dashed ADR-only edge to marker 2, `THE CALL` band: the code unit Test-GlobSetAffected apex.
3. Down the three flow edges that leave it to `WHAT IT RETURNS AND PRINTS` band: marker 3, the result
   $false, return; marker 4, the result
   $true, proceed; marker 5, the result fail-open message.
4. Right along the failure path from the code unit to marker 6, `THE CALL` band: the failure not a declared globset.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                      |
| --------------------- | ----- | ------------------------------------------------------------------------------------------ |
| ADR-only              | 1     | a unit's pipeline stage (`WHO RUNS IT`), dashed pill                                       |
| code unit             | 1     | Test-GlobSetAffected apex (`THE CALL`), wide                                               |
| result                | 3     | $false, return; $true, proceed; fail-open message (`WHAT IT RETURNS AND PRINTS`), in a row |
| failure               | 1     | not a declared globset (`THE CALL`, right of the code unit)                                |

The code unit is slate with a white name, the results green, the failure the only red, and the ADR-only glyph a dashed outline on the page.

## Edges

| Edge kind          | Count | From → to                                                                                                                             |
| ------------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------- |
| flow: produces     | 3     | Test-GlobSetAffected apex → $false, return; Test-GlobSetAffected apex → $true, proceed; Test-GlobSetAffected apex → fail-open message |
| failure path       | 1     | Test-GlobSetAffected apex → not a declared globset                                                                                    |
| ADR-only (no code) | 1     | a unit's pipeline stage → Test-GlobSetAffected apex, dashed                                                                           |

Every edge is straight, vertical or horizontal, and none crosses another. No edge carries a label or a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate rounded box | code unit                  |
| dashed outline    | ADR-only                   |
| green rounded box | result                     |
| red rounded box   | failure                    |
| thin arrow        | flow: produces             |
| red arrow         | failure path               |
| dashed arrow      | ADR-only (no code)         |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--stop-only-on-false-everything-else-proceeds--operations.chain.md), which hold the
reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
