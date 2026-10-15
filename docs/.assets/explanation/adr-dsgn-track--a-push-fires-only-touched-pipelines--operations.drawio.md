---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.md
    kind: asset-description
    body_sha: "51409d5b04f2"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# A push fires only the pipelines it touches: the diagram described

```text
A 1572 x 740 diagram, read left to right through three bands above a full-width band.
Glyphs: 3 named sets (mauve), 3 runners (slate), 1 gate, 1 failure; 5 edges; 7 markers.
Sidebar: world-map grid (5 lit cells), tree (11 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/design/a-push-fires-only-touched-pipelines.md).

## At a glance

A 1572 × 740 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Three side-by-side bands read left to right,
labelled YOU CHANGE, DEPLOYABLE-UNITS and PIPELINES, above a full-width band labelled TRIGGER DRIFT. It holds eight glyphs (three named
sets, three runners, one gate and one failure) joined by five edges, with seven markers and a legend panel along the bottom. The eye lands
first on the tall named set in the YOU CHANGE band.

## Reading path

1. Marker 1, YOU CHANGE band, top: the named set automation/\*\*, with a long edge right to marker 2, the runner ci-automation.
2. Marker 3, PIPELINES band, middle: the runner ci-infrastructure, reached by a long edge from the tall named set infrastructure/\*\*.
3. Marker 4, just below the thick edge from infrastructure/\*\* to the named set nova · apex · flux · shared.
4. Marker 5, PIPELINES band, bottom: the runner cd-&lt;unit&gt;.
5. Markers 6 and 7, TRIGGER DRIFT band: the gate Test-AdoPipelineTriggerGlob and, along a red edge to its right, the failure trigger
   drifted.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                      |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------------------------- |
| named set             | 3     | automation/\*\*, infrastructure/\*\* (YOU CHANGE, the second tall); nova · apex · flux · shared (DEPLOYABLE-UNITS, bottom) |
| runner                | 3     | ci-automation, ci-infrastructure, cd-&lt;unit&gt; (PIPELINES, one per row)                                                 |
| gate                  | 1     | Test-AdoPipelineTriggerGlob (TRIGGER DRIFT, centre right)                                                                  |
| failure               | 1     | trigger drifted (TRIGGER DRIFT, right)                                                                                     |

Named sets are mauve and runners slate, both with white names; the gate is a grey rhombus with a thick rim, the failure red.

## Edges

| Edge kind    | Count | From → to                                                                                                               |
| ------------ | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| flow         | 3     | automation/\*\* → ci-automation, infrastructure/\*\* → ci-infrastructure, nova · apex · flux · shared → cd-&lt;unit&gt; |
| thick        | 1     | infrastructure/\*\* → nova · apex · flux · shared (marker 4)                                                            |
| failure path | 1     | Test-AdoPipelineTriggerGlob → trigger drifted                                                                           |

Every edge is straight and horizontal, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                              |
| ----------------------- | ----------------------------------- |
| mauve rounded box       | named set                           |
| slate pill              | runner                              |
| grey rhombus, thick rim | gate                                |
| red rounded box         | failure                             |
| thin arrow              | flow: a change here fires the next  |
| thick arrow             | thick: a change re-keys a named set |
| red arrow               | failure path                        |
| dark disc `1`           | marker: a Walkthrough step          |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.grid.md),
[tree](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.tree.md) and
[value-chain map](adr-dsgn-track--a-push-fires-only-touched-pipelines--operations.chain.md). A file or ADR lights a minimap when it cites,
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
- **Lens badge:** OPS, with "Supports ADR-DSGN-TRACK" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
