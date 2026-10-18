---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/flow/one-boolean-answer-from-one-function.drawio.md
    folder: docs/explanation/flow
    name: one-boolean-answer-from-one-function-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.tree.md
      - docs/explanation/flow/one-boolean-answer-from-one-function.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# One function answers "am I in a pipeline?", and every branch on context asks it: the diagram described

```text
A 1572 x 640 diagram, read left to right through three bands, then down to a fourth.
Glyphs: 1 runner (slate), 1 code unit (slate), 1 named set (mauve), 1 gate (neutral); 2 flow edges, 1 thick edge; 4 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](one-boolean-answer-from-one-function.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands on one row, labelled `PLATFORM`, `DETECTION` and `CONSUMERS`, then down into a full-width fourth band, `ENFORCEMENT`. It holds four
glyphs, one of each kind, joined by three edges, with four markers and a legend panel along the bottom. The eye lands first on the mauve
named set in the `CONSUMERS` band, the widest glyph on the row.

## Reading path

1. Marker 1, `PLATFORM` band: the runner, pipeline agent.
2. Along the flow edge to marker 2, `DETECTION` band: the code unit, one detection function.
3. Along the thick edge to marker 3, `CONSUMERS` band: the named set, context-dependent behavior.
4. Down the flow edge to marker 4, `ENFORCEMENT` band: the gate, analyzer rule.

## Glyphs

| Glyph (legend phrase) | Count | Where                                             |
| --------------------- | ----- | ------------------------------------------------- |
| runner                | 1     | pipeline agent (`PLATFORM` band)                  |
| code unit             | 1     | one detection function (`DETECTION` band)         |
| named set             | 1     | context-dependent behavior (`CONSUMERS` band)     |
| gate                  | 1     | analyzer rule (`ENFORCEMENT` band, under the set) |

The runner and the code unit are slate, the named set is mauve, all with light names; the gate is a neutral rhombus with a thick light rim.

## Edges

| Edge kind                 | Count | From → to                                                                           |
| ------------------------- | ----- | ----------------------------------------------------------------------------------- |
| flow: feeds the next step | 2     | pipeline agent → one detection function; context-dependent behavior → analyzer rule |
| thick, to a named set     | 1     | one detection function → context-dependent behavior                                 |

The two edges on the top row are horizontal; the edge into the gate is vertical. None crosses another, and none carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| slate pill        | runner                     |
| slate rounded box | code unit                  |
| mauve rounded box | named set                  |
| neutral rhombus   | gate                       |
| thin arrow        | flow: feeds the next step  |
| thick arrow       | to a named set             |
| light disc `1`    | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-DETECT): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.grid.md),
[tree](../.assets/tree/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-detect--one-boolean-answer-from-one-function--meta.chain.md), which hold the reason for every
lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-FLOW-CD-DETECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
