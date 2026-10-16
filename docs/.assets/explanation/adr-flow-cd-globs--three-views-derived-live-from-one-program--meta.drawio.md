---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: f81bc722efc4
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md
      - docs/explanation/flow/three-views-derived-live-from-one-program.md
---

# One program, three views derived live: the diagram described

```text
A 1572 x 560 diagram, read left to right through three bands.
Glyphs: 1 file (olive), 4 code units (slate); 4 flow edges; 5 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/three-views-derived-live-from-one-program.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
bands side by side, labelled `SOURCE`, `FLATTEN` and `DERIVED LIVE`; the last is the widest. It holds five glyphs, one file and four code
units, joined by four straight horizontal edges, with five markers and a legend panel along the bottom. The eye lands first on the tall code
unit in the FLATTEN band.

## Reading path

1. Marker 1, SOURCE band, middle row: the file Registry.
2. Along its edge to marker 2, FLATTEN band: the tall code unit Ordered program.
3. Along three parallel edges to markers 3, 4 and 5, DERIVED LIVE band, top to bottom: the wide code units Trigger, Change report and
   Protection.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                         |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | Registry (SOURCE band, middle row)                                                                            |
| code unit             | 4     | Ordered program (FLATTEN band, all rows); Trigger, Change report, Protection (DERIVED LIVE band, one per row) |

The file is olive and the code units are slate, all with white names.

## Edges

| Edge kind | Count | From → to                                                                       |
| --------- | ----- | ------------------------------------------------------------------------------- |
| flow      | 4     | Registry → Ordered program; Ordered program → each of the three wide code units |

Every edge is straight and horizontal; none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                     |
| ----------------- | -------------------------- |
| olive folded page | file                       |
| slate rounded box | code unit                  |
| thin arrow        | flow: derives the next     |
| grey band         | band: one stage            |
| dark disc `1`     | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.grid.md),
[tree](adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.tree.md) and
[value-chain map](adr-flow-cd-globs--three-views-derived-live-from-one-program--meta.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
