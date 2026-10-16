---
catzc:
  immutable:
    with_body_sha: "7f82e648f56e"
    path: docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-auto-bundle-every-entry-runs-one-load-sequence-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md
      - docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md
      - docs/.assets/explanation/adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md
      - docs/explanation/automation/every-entry-runs-one-load-sequence.md
      - docs/references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md
      - docs/references/automation/catzc-base-maps.md
      - docs/references/automation/catzc-base-maps/Get-WorldMap.ps1.md
---

# Every entry runs one load sequence: the diagram described

```text
A 1572 x 624 diagram, read top to bottom down one column in one band.
Glyphs: 4 code units (slate), 1 gate; 4 flow edges; 5 markers.
Sidebar: three minimaps and the map key, generated from the current maps (see Sidebar).
```

This describes what the [diagram](adr-auto-bundle--every-entry-runs-one-load-sequence--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/every-entry-runs-one-load-sequence.md).

## At a glance

A 1572 × 624 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one centred
column inside a full-width band labelled LOAD SEQUENCE. It holds five glyphs, four code units and one gate, joined by four straight edges,
with five markers and a legend panel along the bottom. The eye lands first on the gate, the only rhombus, fourth in the column.

## Reading path

1. Marker 1, top of the column: the code unit Enter.
2. Markers 2 and 3: the code units Set up the session and Load.
3. Marker 4, on the gate's left point: the gate Prove one run mode.
4. Marker 5, bottom of the column: the code unit Tidy, then leave.

## Glyphs

| Glyph (legend phrase) | Count | Where                     |
| --------------------- | ----- | ------------------------- |
| code unit             | 4     | column rows 1, 2, 3 and 5 |
| gate                  | 1     | column row 4              |

Code units are slate with white names; the gate is a light grey rhombus with a thick rim.

## Edges

| Edge kind        | Count | From → to                                       |
| ---------------- | ----- | ----------------------------------------------- |
| flow (runs next) | 4     | each glyph to the one below it, down the column |

Every edge is short, straight and vertical. None carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| thin arrow              | flow: runs next            |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar is generated, never described here. It holds three minimaps and the map key, lit for the ADR codes this slide supports
(ADR-AUTO-BUNDLE): what `Get-WorldMapHighlight` and `Get-ValueChainHighlight` return today
([Catzc.Base.Maps](../../references/automation/catzc-base-maps.md), the lit-cells and value-chain responsibilities; placement by
[Get-WorldMap](../../references/automation/catzc-base-maps/Get-WorldMap.ps1.md); citations by
[Get-AdrCitationMap](../../references/automation/catzc-base-docs/Get-AdrCitationMap.ps1.md)). To rebuild it, run the fail-forward
renderer with minimaps on this slide (`.claude/drawio/drawio_forward.py <slide> --minimaps`): it derives the codes from the slide,
computes the highlights, draws the three minimaps and writes their sister descriptions, [world map](adr-auto-bundle--every-entry-runs-one-load-sequence--meta.grid.md),
[tree](adr-auto-bundle--every-entry-runs-one-load-sequence--meta.tree.md) and [value-chain map](adr-auto-bundle--every-entry-runs-one-load-sequence--meta.chain.md), which hold the reason for every lit cell or group as of that build.

- **Lens badge:** META, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
