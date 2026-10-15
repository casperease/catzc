---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.md
    kind: asset-description
    body_sha: "64e2072921aa"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
    links:
      - docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md
      - docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.png
      - docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md
      - docs/.assets/explanation/adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md
      - docs/explanation/design/ingress-gated-the-rest-by-review.md
---

# Only ingress is checked by gates: the diagram described

```text
A 1572 x 680 diagram, read top to bottom through three bands: LOCAL CLONE, SERVER REMOTE, OUT.
Glyphs: 3 stores (slate), 2 gates, 1 ADR-only gate, 1 failure; 2 flow, 1 failure path, 3 ADR-only edges; 4 rule chips; 7 markers.
Sidebar: world-map grid (5 lit cells), tree (7 lit groups), value-chain map (5 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/ingress-gated-the-rest-by-review.md).

## At a glance

A 1572 × 680 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through three
full-width bands labelled LOCAL CLONE, SERVER REMOTE and OUT, and steps right as it descends. It holds seven glyphs, three stores, two
gates, one ADR-only gate and one failure, joined by six edges, with four rule chips, seven markers and a legend panel along the bottom. The
eye lands first on the red failure at the top right of the LOCAL CLONE band.

## Reading path

1. Marker 1, LOCAL CLONE band, left: the store local clone.
2. Right to marker 2: the gate local guard, with the chip V6 above its right corner.
3. Right along the red edge to marker 3: the failure Skipped on main.
4. Back to the local guard and down a dashed edge to marker 4, SERVER REMOTE band: the gate branch policy, chip R4.
5. Right to marker 5: the store server main, chip R1.
6. Down a dashed edge to marker 6, OUT band: the ADR-only gate code review in a dashed frame, chip R2 · R3 · L6.
7. Right along a dashed edge to marker 7: the store consumer clones.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                    |
| --------------------- | ----- | -------------------------------------------------------------------------------------------------------- |
| store                 | 3     | local clone (LOCAL CLONE, left), server main (SERVER REMOTE, centre right), consumer clones (OUT, right) |
| gate                  | 2     | local guard (LOCAL CLONE), branch policy (SERVER REMOTE), one above the other                            |
| ADR-only              | 1     | code review: a white dashed rhombus in a dashed frame (OUT, centre right)                                |
| failure               | 1     | Skipped on main (LOCAL CLONE, centre right)                                                              |

Stores are slate with white names.

## Edges

| Edge kind    | Count | From → to                                                                             |
| ------------ | ----- | ------------------------------------------------------------------------------------- |
| flow         | 2     | local clone → local guard, branch policy → server main                                |
| failure path | 1     | local guard → Skipped on main                                                         |
| ADR-only     | 3     | local guard → branch policy, server main → code review, code review → consumer clones |

Every edge is straight; none crosses another. Four rule chips sit beside glyphs: V6, R4, R1 and R2 · R3 · L6.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                      | Phrase                                       |
| --------------------------- | -------------------------------------------- |
| slate cylinder              | store                                        |
| rhombus with a thick rim    | gate                                         |
| red rounded box             | failure                                      |
| dashed box and dashed arrow | ADR-only (no code): glyph or edge            |
| solid arrow                 | flow: a commit moves to                      |
| red arrow                   | failure path                                 |
| white chip `R4`             | rule chip: R = REMOTE, V = VARIANT, L = LIFE |
| dark disc `1`               | marker: a Walkthrough step                   |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.grid.md),
[tree](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.tree.md) and
[value-chain map](adr-dsgn-remote--ingress-gated-the-rest-by-review--governance.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-LIFE, ADR-DSGN-REMOTE, ADR-REPO-VARIANT); the explanation articles, these descriptions and the
drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 5 lit cells, `.claude × .md` (1 file: 1 cites ADR-DSGN-LIFE);
  `automation × .cs` (1 file: 1 cites ADR-REPO-VARIANT); `automation × .ps1` (1 file: 1 cites ADR-REPO-VARIANT); `automation × .yml` (3
  files: 3 cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE, ADR-REPO-VARIANT); `docs × .md` (7 files: 4 cite ADR-DSGN-LIFE, ADR-DSGN-REMOTE,
  ADR-REPO-VARIANT; 3 are the ADR file of ADR-DSGN-LIFE, ADR-DSGN-REMOTE, ADR-REPO-VARIANT).
- **Tree** (the repository's files): 7 lit groups, `adr/dsgn` (3 files); `ModuleSystem` (2 files); `Variants` (2 files); `adr/*` (2 files);
  `adr/repo` (2 files); `.claude` (1 file); `Docs` (1 file). The ADR files `docs/adr/design/commit-lifecycle.md`,
  `docs/adr/design/server-remote-integration.md`, `docs/adr/repository/repo-variants.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 5 lit cells: `DSGN × BUILD`, because ADR-DSGN-REMOTE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × QC`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); ADR-DSGN-REMOTE: its ADR domain `design` sits on the
  DSGN row (ADR-DSGN-TRACK#14), and build, quality-control is its own value-chain concern (ADR-DSGN-TRACK#15); `DSGN × RELEASE`, because
  ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own
  value-chain concern (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-LIFE: its ADR domain `design` sits on the DSGN row
  (ADR-DSGN-TRACK#14), and quality-control, release, deploy is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × LOCAL`, because
  ADR-REPO-VARIANT: its ADR domain `repository` sits on the AUTO row (ADR-DSGN-TRACK#14), and automation is its ADR domain's default concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** GOV, with "Supports ADR-DSGN-REMOTE · ADR-DSGN-LIFE / ADR-REPO-VARIANT" beneath it, on two lines.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
