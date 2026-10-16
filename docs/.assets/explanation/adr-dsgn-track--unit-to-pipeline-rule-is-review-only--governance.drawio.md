---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.md
    folder: docs/.assets/explanation
    name: adr-dsgn-track-unit-to-pipeline-rule-is-review-only-governance-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: b01568f3d92e
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md
      - docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png
      - docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md
      - docs/.assets/explanation/adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md
      - docs/explanation/design/unit-to-pipeline-rule-is-review-only.md
---

# Tracks and deployable-units have a gate; one unit to one pipeline is held by review: the diagram described

```text
A 1572 x 600 diagram, three bands side by side, each read top to bottom.
Glyphs: 3 named sets (mauve), 1 runner (slate), 3 gates, 1 ADR-only gate; 5 edges; 8 markers; 4 rule chips.
Sidebar: world-map grid (6 lit cells), tree (17 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/unit-to-pipeline-rule-is-review-only.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three side-by-side bands, labelled TRACKS,
DEPLOYABLE-UNITS and PIPELINES · SCOPES, each read top to bottom: the constrained glyph above, its check below. It holds eight glyphs (three
named sets, one runner, three gates and one ADR-only gate) joined by five downward edges, with eight markers, four rule chips and a legend
panel along the bottom. The eye lands first on the large white rhombus in its dashed frame in the right band.

## Reading path

1. Marker 1, TRACKS band, top: the named set track, with the rule chip T1–4 · T6 · F1,3.
2. Down two edges to markers 2 and 3: the gates VariantsConfig and Get-FileLanguage.Tests.
3. Marker 4, DEPLOYABLE-UNITS band, top: the named set deployable-unit, with the rule chip G7 · G8; down to marker 5, the gate GlobsConfig.
4. Markers 6 and 7, PIPELINES · SCOPES band, top: the runner pipeline (chip T5) and the named set `scope globset` (chip T2).
5. Down two dashed edges to marker 8: the ADR-only gate code review, inside a dashed frame.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                               |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------- |
| named set             | 3     | track (TRACKS, top), deployable-unit (DEPLOYABLE-UNITS, top), scope globset (right band, top right) |
| runner                | 1     | pipeline (right band, top left)                                                                     |
| gate                  | 3     | VariantsConfig, Get-FileLanguage.Tests (TRACKS, bottom), GlobsConfig (DEPLOYABLE-UNITS, bottom)     |
| ADR-only              | 1     | code review (right band, bottom), a white rhombus inside a dashed frame                             |

Named sets are mauve and the runner slate, both with white names; the gates are grey rhombi with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                             |
| --------- | ----- | ------------------------------------------------------------------------------------- |
| flow      | 3     | track → VariantsConfig, track → Get-FileLanguage.Tests, deployable-unit → GlobsConfig |
| ADR-only  | 2     | pipeline → code review, scope globset → code review                                   |

Every edge is straight and vertical, and none crosses another. Four rule chips sit on the top-right corners of the four upper glyphs.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                                                                     |
| ----------------------- | -------------------------------------------------------------------------- |
| mauve rounded box       | named set                                                                  |
| slate pill              | runner                                                                     |
| grey rhombus, thick rim | gate                                                                       |
| dashed white box        | ADR-only: review, no code (glyph or edge)                                  |
| thin arrow              | flow: is checked by                                                        |
| white chip `T5`         | rule chip: T = ADR-DSGN-TRACK, G = ADR-FLOW-CD-GLOBS, F = ADR-REPO-FOLDERS |
| dark disc `1`           | marker: a Walkthrough step                                                 |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.grid.md),
[tree](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.tree.md) and
[value-chain map](adr-dsgn-track--unit-to-pipeline-rule-is-review-only--governance.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); the explanation articles, these descriptions and
the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (26 files: 26 cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); `automation × .ps1` (66
  files: 66 cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); `automation × .yml` (11 files: 11 cite ADR-DSGN-TRACK,
  ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); `docs × .md` (13 files: 10 cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS; 3 are the ADR
  file of ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS, ADR-REPO-FOLDERS); `pipelines × .yaml` (6 files: 6 cite ADR-DSGN-TRACK, ADR-FLOW-CD-GLOBS). 1
  cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 17 lit groups, `Globs` (38 files); `Maps` (29 files); `Languages` (9 files); `Docs` (8 files);
  `QualityGates` (6 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files); `docs` (5 files); `Variants` (4 files);
  `ModuleSystem` (2 files); `adr/*` (2 files); `adr/dsgn` (2 files); `adr/flow` (2 files); `adr/repo` (2 files); `.github` (1 file);
  `Contracts` (1 file); `Exporter` (1 file). The ADR files `docs/adr/design/tracks.md`, `docs/adr/flow/durable-sha-globs.md`,
  `docs/adr/repository/conventional-folders.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-TRACK: its
  ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern (ADR-DSGN-TRACK#15);
  ADR-FLOW-CD-GLOBS: its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern
  (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because ADR-REPO-FOLDERS: its ADR domain `repository` sits on the AUTO row (ADR-DSGN-TRACK#14), and
  automation is its ADR domain's default concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-DSGN-TRACK · ADR-FLOW-CD-GLOBS · ADR-REPO-FOLDERS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
