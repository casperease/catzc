---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "938604bc980e"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md
      - docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.png
      - docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md
      - docs/.assets/explanation/adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md
      - docs/explanation/design/units-not-tracks-own-the-pipelines.md
---

# CD binds through units, CI binds track sets: the diagram described

```text
A 1572 x 600 diagram, read left to right through three bands.
Glyphs: 4 named sets (mauve), 3 runners (slate); 6 edges; 6 markers; 1 count chip.
Sidebar: world-map grid (5 lit cells), tree (11 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/units-not-tracks-own-the-pipelines.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through three
side-by-side bands, labelled TRACKS, DEPLOYABLE-UNITS and PIPELINES. It holds seven glyphs (four named sets and three runners) joined by six
edges, with six markers, one count chip and a legend panel along the bottom. The eye lands first on the tall named set in the TRACKS band.

## Reading path

1. Marker 1, TRACKS band, top: the named set automation.
2. Marker 2, beside the dashed edge that rises from infrastructure to automation.
3. Marker 3, just below the long edge from automation across to the runner ci-automation; the parallel edge below runs from infrastructure
   to ci-infrastructure.
4. Markers 4 and 5, DEPLOYABLE-UNITS band, bottom row: the named sets foundation base unit and nova · apex · flux · shared, joined by a
   thick edge, with a thick edge entering the first from infrastructure.
5. Marker 6, PIPELINES band, bottom: the runner cd-&lt;unit&gt;, with the count chip 4 on its top-right corner.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------- |
| named set             | 4     | automation, infrastructure (TRACKS band, the second tall); foundation base unit, nova · apex · flux · shared (DEPLOYABLE-UNITS, bottom) |
| runner                | 3     | ci-automation, ci-infrastructure, cd-&lt;unit&gt; (PIPELINES band, one per row)                                                         |

Named sets are mauve and runners slate, both with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| flow      | 3     | automation → ci-automation (marker 3), infrastructure → ci-infrastructure, nova · apex · flux · shared → cd-&lt;unit&gt; |
| thick     | 2     | infrastructure → foundation base unit, foundation base unit → nova · apex · flux · shared                                |
| ADR-only  | 1     | infrastructure → automation (vertical, dashed, marker 2)                                                                 |

Every edge is straight; five are horizontal and one is vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                    | Phrase                               |
| ------------------------- | ------------------------------------ |
| mauve rounded box         | named set                            |
| slate pill                | runner                               |
| thin arrow                | flow: binds a pipeline (pipeline:)   |
| thick arrow               | thick: composes into, to a named set |
| dashed arrow              | ADR-only: rests on (no gate)         |
| white pill `4`, slate rim | count chip: pipelines it stands for  |
| dark disc `1`             | marker: a Walkthrough step           |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.grid.md),
[tree](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.tree.md) and
[value-chain map](adr-dsgn-track--units-not-tracks-own-the-pipelines--architecture.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-TRACK); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .cs` (18 files: 18 cite ADR-DSGN-TRACK);
  `automation × .ps1` (23 files: 23 cite ADR-DSGN-TRACK); `automation × .yml` (8 files: 8 cite ADR-DSGN-TRACK); `docs × .md` (6 files: 5
  cite ADR-DSGN-TRACK; 1 is the ADR file of ADR-DSGN-TRACK); `pipelines × .yaml` (1 file: 1 cites ADR-DSGN-TRACK).
- **Tree** (the repository's files): 11 lit groups, `Maps` (29 files); `Languages` (6 files); `Docs` (5 files); `Variants` (4 files);
  `Globs` (2 files); `QualityGates` (2 files); `adr/*` (2 files); `adr/dsgn` (2 files); `docs` (2 files); `ModuleSystem` (1 file);
  `pipelines` (1 file). The ADR file `docs/adr/design/tracks.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-DSGN-TRACK: its
  ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
