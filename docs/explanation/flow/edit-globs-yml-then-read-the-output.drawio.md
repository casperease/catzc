---
catzc:
  immutable:
    with_body_sha: "0e95c25d7466"
    repo_status: clean
    path: docs/explanation/flow/edit-globs-yml-then-read-the-output.drawio.md
    folder: docs/explanation/flow
    name: edit-globs-yml-then-read-the-output-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/explanation/.assets/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.png
      - docs/explanation/.assets/chain/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
      - docs/explanation/.assets/grid/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
      - docs/explanation/.assets/tree/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
      - docs/explanation/flow/edit-globs-yml-then-read-the-output.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Edit globs.yml, then read the output: the diagram described

```text
A 1572 x 560 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 1 gate, 3 code units (slate), 3 results (green); 7 flow edges; 8 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](../.assets/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](edit-globs-yml-then-read-the-output.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands side by side, labelled YOU EDIT, CONFIG LOAD, YOU RUN and YOU SEE. It holds eight glyphs, one file, one gate, three code units and
three results, joined by seven straight edges, with eight markers and a legend panel along the bottom. The eye lands first on the tall
rhombus in the CONFIG LOAD band, the gate.

## Reading path

1. Marker 1, YOU EDIT band, middle row: the file globs.yml.
2. Along its edge to marker 2, at the top vertex of the gate Config load, a tall rhombus.
3. Along three edges leaving the gate's right side to markers 3, 4 and 5, YOU RUN band, top to bottom: the code units Get-GlobSetTrigger,
   Get-ChangedGlobSet and Test-Automation.
4. Along three edges to markers 6, 7 and 8, YOU SEE band: the results Projected paths, Touched globsets and Skip line.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------- |
| file                  | 1     | globs.yml (YOU EDIT band, middle row)                                  |
| gate                  | 1     | Config load (CONFIG LOAD band, all rows), 3 px rim                     |
| code unit             | 3     | Get-GlobSetTrigger, Get-ChangedGlobSet, Test-Automation (YOU RUN band) |
| result                | 3     | Projected paths, Touched globsets, Skip line (YOU SEE band)            |

The file is olive and the code units are slate, both with white names; the gate is grey and the results light green.

## Edges

| Edge kind | Count | From → to                                                                                                   |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------- |
| flow      | 7     | globs.yml → Config load; Config load → each of the three code units; each code unit → the result in its row |

Every edge is straight and horizontal; none crosses another. The top and bottom edges leave the gate from its slanted sides.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                     |
| ---------------------- | -------------------------- |
| olive folded page      | file                       |
| grey rhombus, 3 px rim | gate                       |
| slate rounded box      | code unit                  |
| green rounded box      | result                     |
| thin arrow             | flow: feeds, then prints   |
| dark disc `1`          | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward renderer
with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide, computes the
highlights, draws the three minimaps and writes their sister descriptions,
[world map](../.assets/grid/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md),
[tree](../.assets/tree/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md) and
[value-chain map](../.assets/chain/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md), which hold the reason for
every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
