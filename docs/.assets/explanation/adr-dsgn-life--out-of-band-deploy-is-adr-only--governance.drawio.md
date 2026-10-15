---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.md
    kind: asset-description
    body_sha: "58c9f6a27cb6"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# No gate checks the out-of-band deploy rule: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 2 gates, 1 environment, 1 ADR-only; 4 flow edges, 2 ADR-only edges; 6 rule chips; 6 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/out-of-band-deploy-is-adr-only.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds eight glyphs: four commits, two gates, one environment and one ADR-only glyph, plus six rule chips. A straight flow
line runs across the top row from the brown commit to the yellow one; a dashed path drops from the brown commit into the OUT-OF-BAND band,
and a short flow edge drops from the grey commit to a second gate. Six markers number the reading order, and a legend panel runs along the
bottom.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic, with the rule chips V2 and V4 to its left.
2. Down the dashed edge and right to marker 2, OUT-OF-BAND band: the dashed white pill, out-of-band deploy, with the chip L9.
3. Down the dashed edge to marker 3: the environment hexagon with a small brown commit inside, and the chip V13.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main, with the chip L1.
5. Down the flow edge to marker 5, MAIN band: the gate main only.
6. Marker 6, AFTER LANDING band: the gate BVT, then on to the yellow commit BVT-verified, with the chip V4.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| commit                | 4     | brown topic (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 2     | main only (MAIN, middle), BVT (AFTER LANDING, top row); both with a 3 px rim                                            |
| environment           | 1     | environment (OUT-OF-BAND, bottom)                                                                                       |
| ADR-only              | 1     | out-of-band deploy (OUT-OF-BAND, middle), a dashed white pill                                                           |

The commits keep the locked commit palette; the gates and the environment are neutral grey. Six rule chips sit beside the glyphs they
govern: V2 and V4 left of topic, L9 right of out-of-band deploy, V13 right of the environment, L1 above-right of main, and V4 right of
BVT-verified.

## Edges

| Edge kind | Count | From → to                                                                                                                                                                            |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow      | 4     | topic → main, main → BVT, BVT → BVT-verified, main → main only                                                                                                                       |
| ADR-only  | 2     | topic → out-of-band deploy (one dashed edge drawn as two cells: a down leg with no arrowhead to a bend point, then a right leg with the arrowhead), out-of-band deploy → environment |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                            | Phrase                                            |
| --------------------------------- | ------------------------------------------------- |
| brown, grey and yellow discs      | commit (locked palette)                           |
| grey rhombus with a thick rim     | gate: code checks it                              |
| grey hexagon                      | environment: its occupant inside                  |
| dashed white box and dashed arrow | ADR-only (no code): glyph or edge                 |
| white chip `L9`                   | rule chip: L = ADR-DSGN-LIFE, V = ADR-DSGN-VISUAL |
| thin arrow                        | flow: lands, then climbs                          |
| dark disc `1`                     | marker: a Walkthrough step                        |
| crossbar                          | span bar: stages over bands                       |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.grid.md),
[tree](adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.tree.md) and
[value-chain map](adr-dsgn-life--out-of-band-deploy-is-adr-only--governance.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-DSGN-LIFE, ADR-DSGN-VISUAL); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 3 lit cells, `.claude × .md` (2 files: 2 cite ADR-DSGN-LIFE,
  ADR-DSGN-VISUAL); `automation × .yml` (3 files: 3 cite ADR-DSGN-LIFE, ADR-DSGN-VISUAL); `docs × .md` (5 files: 3 cite ADR-DSGN-LIFE,
  ADR-DSGN-VISUAL; 2 are the ADR file of ADR-DSGN-LIFE, ADR-DSGN-VISUAL).
- **Tree** (the repository's files): 5 lit groups, `adr/dsgn` (3 files); `.claude` (2 files); `Docs` (2 files); `adr/*` (2 files);
  `ModuleSystem` (1 file). The ADR files `docs/adr/design/commit-lifecycle.md`, `docs/adr/design/visual-design.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 3 lit cells: `DSGN × QC`, because ADR-DSGN-LIFE: its ADR
  domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release,
  deploy is its own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-VISUAL: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-DSGN-LIFE · ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
