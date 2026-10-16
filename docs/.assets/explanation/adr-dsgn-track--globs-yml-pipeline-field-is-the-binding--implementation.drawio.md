---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "4cf8ead86ed1"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md
      - docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.png
      - docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md
      - docs/.assets/explanation/adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md
      - docs/explanation/design/globs-yml-pipeline-field-is-the-binding.md
---

# globs.yml's pipeline: field is the binding: the diagram described

```text
A 1572 x 640 diagram: one file holding four named sets, read left to right into a band of runners.
Glyphs: 1 file (olive), 4 named sets (mauve), 4 runners (slate); 5 edges; 7 markers; 1 fraction chip.
Sidebar: world-map grid (5 lit cells), tree (11 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.drawio.png) draws, in the
vocabulary of the diagram glyphs; what it means is in [the article](../../explanation/design/globs-yml-pipeline-field-is-the-binding.md).

## At a glance

A 1572 × 640 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The left half is one large file glyph labelled
globs.yml, its name centred at the top, that holds four named sets stacked in a column; the right half is a band labelled PIPELINES with
four runners. It holds nine glyphs (one file, four named sets, four runners) joined by five edges, with seven markers, one fraction chip and
a legend panel along the bottom. The eye lands first on the large olive file page.

## Reading path

1. Marker 1, the top-left corner of the file glyph globs.yml.
2. Markers 2, 3 and 4, down the column inside it: the named sets automation:, infrastructure: and nova: · apex: · flux: · shared:, each with
   an edge right to a runner.
3. Marker 5, bottom of the column: the named set foundation base unit, with a thick edge up into the set above it.
4. Marker 6, PIPELINES band, third row: the runner cd-&lt;unit&gt;.yaml.
5. Marker 7, just below the short edge right to the runner extends/cd-customer.yaml, with the fraction chip 3/4 above it.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                      |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | globs.yml, the large page on the left that holds the named sets                                                            |
| named set             | 4     | automation:, infrastructure:, nova: · apex: · flux: · shared:, foundation base unit (one column, top to bottom)            |
| runner                | 4     | ci-automation.yaml, ci-infrastructure.yaml, cd-&lt;unit&gt;.yaml (one column); extends/cd-customer.yaml (third row, right) |

The file is olive, named sets mauve and runners slate, all with white names.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 4     | automation: → ci-automation.yaml, infrastructure: → ci-infrastructure.yaml, nova: · apex: · flux: · shared: → cd-&lt;unit&gt;.yaml, cd-&lt;unit&gt;.yaml → extends/cd-customer.yaml (marker 7) |
| thick     | 1     | foundation base unit → nova: · apex: · flux: · shared: (vertical, upward)                                                                                                                      |

Every edge is straight and none crosses another. The fourth row holds no runner.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch            | Phrase                                          |
| ----------------- | ----------------------------------------------- |
| olive page        | file                                            |
| mauve rounded box | named set                                       |
| slate pill        | runner                                          |
| thin arrow        | flow: names the next file by key                |
| thick arrow       | thick: composes into (compose:), to a named set |
| bold `3/4`        | fraction chip: pipelines that extend it         |
| dark disc `1`     | marker: a Walkthrough step                      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.grid.md),
[tree](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.tree.md) and
[value-chain map](adr-dsgn-track--globs-yml-pipeline-field-is-the-binding--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-DSGN-TRACK); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `automation × .cs` (18 files: 18 cite ADR-DSGN-TRACK);
  `automation × .ps1` (23 files: 23 cite ADR-DSGN-TRACK); `automation × .yml` (8 files: 8 cite ADR-DSGN-TRACK); `docs × .md` (6 files: 5
  cite ADR-DSGN-TRACK; 1 is the ADR file of ADR-DSGN-TRACK); `pipelines × .yaml` (1 file: 1 cites ADR-DSGN-TRACK).
- **Tree** (the repository's files): 11 lit groups, `Maps` (29 files); `Languages` (6 files); `Docs` (5 files); `Variants` (4 files);
  `Globs` (2 files); `QualityGates` (2 files); `adr/*` (2 files); `adr/dsgn` (2 files); `docs` (2 files); `ModuleSystem` (1 file);
  `pipelines` (1 file). The ADR file `docs/adr/design/tracks.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-DSGN-TRACK: its
  ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** IMPL, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
