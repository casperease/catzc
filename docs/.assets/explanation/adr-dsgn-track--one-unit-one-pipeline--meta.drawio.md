---
catzc:
  immutable:
    with_body_sha: "395e9272a0b7"
    path: docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-track-one-unit-one-pipeline-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-track--one-unit-one-pipeline--meta.tree.md
      - docs/explanation/design/one-unit-one-pipeline.md
---

# One unit, one pipeline; tracks ship through units: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 2 named sets (mauve), 1 runner (slate); 1 thick edge, 1 flow edge; 5 markers.
Sidebar: world-map grid (5 lit cells), tree (11 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-dsgn-track--one-unit-one-pipeline--meta.drawio.png) draws, in the vocabulary of the diagram glyphs;
what it means is in [the article](../../explanation/design/one-unit-one-pipeline.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds three glyphs (two named sets and one runner) in one row,
joined by two edges, with five markers and a legend panel below. The drawing area ends at about 390 px; the sidebar runs to the canvas foot.
The eye lands first on the left named set.

## Reading path

1. Marker 1, TRACKS band: the named set Track.
2. Marker 2, beside the thick edge right to the next band.
3. Marker 3, DEPLOYABLE-UNITS band: the named set Deployable-unit.
4. Marker 4, beside the thin edge right to the last band.
5. Marker 5, PIPELINES band: the runner Pipeline.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                        |
| --------------------- | ----- | ------------------------------------------------------------ |
| named set             | 2     | Track (TRACKS band), Deployable-unit (DEPLOYABLE-UNITS band) |
| runner                | 1     | Pipeline (PIPELINES band)                                    |

Named sets are mauve and the runner is slate, both with white names.

## Edges

| Edge kind | Count | From → to                             |
| --------- | ----- | ------------------------------------- |
| thick     | 1     | Track → Deployable-unit (marker 2)    |
| flow      | 1     | Deployable-unit → Pipeline (marker 4) |

Both edges are straight and horizontal, on one line; each edge marker sits just below its line, its rim touching it.

## Legend

A full-width panel below the bands, in three columns, left to right:

| Swatch            | Phrase                               |
| ----------------- | ------------------------------------ |
| mauve rounded box | named set                            |
| slate pill        | runner                               |
| thick arrow       | thick: composes into, to a named set |
| thin arrow        | flow: binds one pipeline (1-1)       |
| dark disc `1`     | marker: a Walkthrough step           |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-track--one-unit-one-pipeline--meta.grid.md), [tree](adr-dsgn-track--one-unit-one-pipeline--meta.tree.md) and
[value-chain map](adr-dsgn-track--one-unit-one-pipeline--meta.chain.md). A file or ADR lights a minimap when it cites, or is, the ADR the
slide supports (ADR-DSGN-TRACK); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .cs` (18 files: 18 cite ADR-DSGN-TRACK);
  `automation × .ps1` (23 files: 23 cite ADR-DSGN-TRACK); `automation × .yml` (8 files: 8 cite ADR-DSGN-TRACK); `docs × .md` (6 files: 5
  cite ADR-DSGN-TRACK; 1 is the ADR file of ADR-DSGN-TRACK); `pipelines × .yaml` (1 file: 1 cites ADR-DSGN-TRACK).
- **Tree** (the repository's files): 11 lit groups, `Maps` (29 files); `Languages` (6 files); `Docs` (5 files); `Variants` (4 files);
  `Globs` (2 files); `QualityGates` (2 files); `adr/*` (2 files); `adr/dsgn` (2 files); `docs` (2 files); `ModuleSystem` (1 file);
  `pipelines` (1 file). The ADR file `docs/adr/design/tracks.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-DSGN-TRACK: its
  ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
