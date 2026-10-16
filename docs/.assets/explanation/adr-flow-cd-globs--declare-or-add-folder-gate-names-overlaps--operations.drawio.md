---
catzc:
  immutable:
    with_body_sha: f0b5cd3bf16d
    path: docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-flow-cd-globs-declare-or-add-folder-gate-names-overlaps-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md
      - docs/explanation/flow/declare-or-add-folder-gate-names-overlaps.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Declare or add a folder, and the gate names overlaps: the diagram described

```text
A 1572 x 700 diagram, read top to bottom through three bands, the gate at top right.
Glyphs: 3 files (olive), 1 code unit (slate), 1 gate (grey), 2 failures (red).
Edges: 2 flow, 2 failure paths; 7 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/flow/declare-or-add-folder-gate-names-overlaps.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands, labelled DEPLOYABLE-UNIT, LOOSE-FILESET and MODULE. It holds three files, one code unit, one gate and two failures, joined
by two flow edges and two failure paths, with seven markers and a legend panel. The eye lands first on the gate, a large grey rhombus at the
right of the top band.

## Reading path

1. Marker 1, top band, left: the file globs.yml: deployable-unit, with a long edge right to the gate.
2. Marker 2, middle band, left: the file globs.yml: loose-fileset, with no edge.
3. Markers 3 and 4, bottom band, left: the file globs.yml: layer: module and, along a short failure path, the failure Rejected at config
   load.
4. Marker 5, bottom band, right: the wide code unit Add a module folder, with a vertical edge up through the middle band to the gate.
5. Marker 6, on the top vertex of the gate Test-GlobSetIndependence, top band.
6. Marker 7, top band, far right: the failure Issue per pair, at the end of the gate's failure path.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                  |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------ |
| file                  | 3     | globs.yml: deployable-unit (top), globs.yml: loose-fileset (middle), globs.yml: layer: module (bottom) |
| code unit             | 1     | Add a module folder (bottom band, right)                                                               |
| gate                  | 1     | Test-GlobSetIndependence (top band, right)                                                             |
| failure               | 2     | Rejected at config load (bottom band), Issue per pair (top band, far right)                            |

Files are olive and the code unit slate, both with white names; the gate is a grey rhombus with a 3 px rim; the failures are light red.

## Edges

| Edge kind    | Count | From → to                                                                 |
| ------------ | ----- | ------------------------------------------------------------------------- |
| flow         | 2     | globs.yml: deployable-unit → gate, Add a module folder → gate             |
| failure path | 2     | gate → Issue per pair, globs.yml: layer: module → Rejected at config load |

Every edge is straight and none crosses another. The file in the middle band has no edge.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive page        | file                       |
| slate rounded box | code unit                  |
| grey rhombus      | gate                       |
| red rounded box   | failure                    |
| thin arrow        | flow: checked by the gate  |
| red arrow         | failure path               |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-FLOW-CD-GLOBS): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.grid.md),
[tree](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.tree.md) and [value-chain map](adr-flow-cd-globs--declare-or-add-folder-gate-names-overlaps--operations.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
