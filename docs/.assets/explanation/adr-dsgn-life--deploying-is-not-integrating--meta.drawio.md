---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "001a6fa44750"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.chain.md
      - docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.drawio.png
      - docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.grid.md
      - docs/.assets/explanation/adr-dsgn-life--deploying-is-not-integrating--meta.tree.md
      - docs/explanation/design/deploying-is-not-integrating.md
---

# Deploying a topic commit is not integrating it: the diagram described

```text
A 1572 x 630 diagram, read left to right through four column bands.
Glyphs: 4 commits, 1 gate, 1 environment; 3 flow edges, 1 ADR-only edge; 5 markers.
Sidebar: world-map grid (3 lit cells), tree (5 lit groups), value-chain map (3 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-life--deploying-is-not-integrating--meta.drawio.png) draws, in the vocabulary of the diagram
glyphs; what it means is in [the article](../../explanation/design/deploying-is-not-integrating.md).

## At a glance

A 1572 × 630 canvas on a grey-blue page: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to
right through four column bands, labelled TOPIC, OUT-OF-BAND, MAIN and AFTER LANDING, with a span bar labelled CI above the MAIN and AFTER
LANDING bands. It holds six glyphs: four commits, one gate and one environment. A straight flow line runs across the top row from the brown
commit to the yellow one; a dashed edge drops from the brown commit and runs right into the environment. Five markers number the reading
order, and a legend panel runs along the bottom.

## Reading path

1. Marker 1, TOPIC band: the brown commit, labelled topic commit.
2. Marker 2, beside the dashed edge's down leg in the TOPIC band; the edge then turns right into the OUT-OF-BAND band.
3. Marker 3, OUT-OF-BAND band: the environment hexagon, with a small brown commit inside, above its name.
4. Back to the top row, along the flow edge to marker 4, MAIN band: the grey commit, main.
5. Right to marker 5, AFTER LANDING band: the gate BVT, then on to the yellow commit BVT-verified.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                          |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------ |
| commit                | 4     | brown topic commit (TOPIC), grey main (MAIN), yellow BVT-verified (AFTER LANDING), small brown occupant inside the environment |
| gate                  | 1     | BVT (AFTER LANDING, top row), 3 px rim                                                                                         |
| environment           | 1     | environment (OUT-OF-BAND, middle)                                                                                              |

The commits keep the locked commit palette; the gate and the environment are neutral grey.

## Edges

| Edge kind | Count | From → to                                                                                                                                                  |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 3     | topic commit → main, main → BVT, BVT → BVT-verified                                                                                                        |
| ADR-only  | 1     | topic commit → environment (drawn as two cells: a dashed down leg with no arrowhead to a bend point, then a dashed right leg with the arrowhead; marker 2) |

Every edge is straight, horizontal or vertical, and none crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, read top to bottom, left to right:

| Swatch                        | Phrase                           |
| ----------------------------- | -------------------------------- |
| brown, grey and yellow discs  | commit (locked palette)          |
| grey rhombus with a thick rim | gate                             |
| grey hexagon                  | environment: its occupant inside |
| dashed arrow                  | ADR-only (no code)               |
| thin arrow                    | flow: lands, then climbs         |
| dark disc `1`                 | marker: a Walkthrough step       |
| crossbar                      | span bar: stages over bands      |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-life--deploying-is-not-integrating--meta.grid.md), [tree](adr-dsgn-life--deploying-is-not-integrating--meta.tree.md)
and [value-chain map](adr-dsgn-life--deploying-is-not-integrating--meta.chain.md). A file or ADR lights a minimap when it cites, or is, the
ADR the slide supports (ADR-DSGN-LIFE, ADR-DSGN-VISUAL); the explanation articles, these descriptions and the drawing tooling never light
anything.

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
- **Lens badge:** META, with "Supports ADR-DSGN-LIFE · ADR-DSGN-VISUAL" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
