---
catzc:
  derived:
    path: docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "4dc5921ea701"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md
      - docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.png
      - docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md
      - docs/.assets/explanation/adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md
      - docs/explanation/pipelines/which-auth-rungs-have-a-gate.md
---

# Which auth rungs have a gate: the diagram described

```text
A 1572 x 620 diagram in two bands side by side, HEADER FUNCTION and CROSS-CUTTING.
Glyphs: 3 gates, 3 code units (slate), 2 runners (slate); 4 flow edges; 9 rule chips (5 solid, 4 dashed); 5 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/which-auth-rungs-have-a-gate.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. Two bands sit side by side: HEADER FUNCTION on
the left, with the column headings RUNG and CHECKED BY, and CROSS-CUTTING on the right. They hold eight glyphs (three gates, three code
units, two runners) joined by four edges, with nine rule chips (five solid, four dashed), five markers and a legend panel along the bottom.
The eye lands first on the three gates in the left band.

## Reading path

1. Marker 1, beside the HEADER FUNCTION band label: three rule chips, #1 solid, #4 and #7 dashed.
2. Marker 2, left band, top row: the gate Pipeline token, with chips #3 and #2 (both solid) and a flow edge right to the code unit L0 tests.
3. Marker 3, middle row: the gate PAT, with chip #2 (dashed) and a flow edge right to the code unit L0 test.
4. Marker 4, bottom row: the gate az CLI, with chips #2 (solid) and #5 (dashed) and a flow edge right to the code unit L0 tests.
5. Marker 5, right band: the runner invoke-automation.yaml, with chip #6 (solid) and a flow edge down to the runner AzureAuthTests.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                        |
| --------------------- | ----- | ------------------------------------------------------------ |
| gate                  | 3     | Pipeline token, PAT, az CLI (left band, RUNG column)         |
| code unit             | 3     | L0 tests, L0 test, L0 tests (left band, CHECKED BY column)   |
| runner                | 2     | invoke-automation.yaml, AzureAuthTests (right band, stacked) |

Code units and runners are slate with white names; the gates are grey with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                     |
| --------- | ----- | ----------------------------------------------------------------------------- |
| flow      | 4     | each gate → the code unit on its row; invoke-automation.yaml → AzureAuthTests |

Every edge is straight, horizontal or vertical, and none crosses another. The rule chips sit above the edge that leaves each gate.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                               |
| ----------------------- | ------------------------------------ |
| grey rhombus, thick rim | gate                                 |
| slate rounded box       | code unit                            |
| slate pill              | runner                               |
| grey arrow              | flow: checked by                     |
| white chip `#n`         | rule chip: ADR-PIPE-AUTH#n           |
| dashed white chip `#n`  | dashed rule chip: ADR-only (no gate) |
| dark disc `1`           | marker: a Walkthrough step           |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.grid.md),
[tree](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.tree.md) and
[value-chain map](adr-pipe-auth--which-auth-rungs-have-a-gate--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-PIPE-AUTH); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-PIPE-AUTH);
  `docs × .md` (3 files: 2 cite ADR-PIPE-AUTH; 1 is the ADR file of ADR-PIPE-AUTH).
- **Tree** (the repository's files): 3 lit groups, `adr/pipe` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/pipelines/dual-authentication.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `PIPE × ACCESS`, because ADR-PIPE-AUTH: its
  ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and access is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
