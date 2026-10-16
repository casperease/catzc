---
catzc:
  immutable:
    with_body_sha: "9f1128c9dab7"
    path: docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.md
    folder: docs/.assets/explanation
    name: adr-pipe-auth-one-header-function-owns-precedence-architecture-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md
      - docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.png
      - docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md
      - docs/.assets/explanation/adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md
      - docs/explanation/pipelines/one-header-function-owns-precedence.md
---

# One function owns the precedence: the diagram described

```text
A 1572 x 690 diagram, read top to bottom into one band, HEADER FUNCTION.
Glyphs: 2 code units (slate), 3 gates, 1 runner (slate), 1 file (olive); 5 flow edges, 1 ADR-only edge; 7 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-pipe-auth--one-header-function-owns-precedence--architecture.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/pipelines/one-header-function-owns-precedence.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom: a code unit
above a central band, HEADER FUNCTION, which holds three gates stacked in a column. A tall file stands to the left of the band, and a runner
and a code unit stand to its right. It holds seven glyphs (two code units, three gates, one runner, one file) joined by six edges, with
seven markers and a legend panel along the bottom. The eye lands first on the three gates in the band.

## Reading path

1. Marker 1, top centre: the code unit Invoke-AdoRestMethod, with a flow edge down into the band.
2. Marker 2, in the band, top: the gate Pipeline token, with a flow edge right to marker 3, the runner invoke-automation.yaml.
3. Marker 4, in the band, middle: the gate PAT, with an ADR-only edge left to the file.
4. Marker 5, in the band, bottom: the gate az CLI, with a flow edge right to marker 6, the code unit Catzc.Azure.Cli.
5. Marker 7, left: the file ado.yml, which receives one edge from each gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------- |
| code unit             | 2     | Invoke-AdoRestMethod (top centre), Catzc.Azure.Cli (right, bottom row) |
| gate                  | 3     | Pipeline token, PAT, az CLI (inside the band, top to bottom)           |
| runner                | 1     | invoke-automation.yaml (right, top row)                                |
| file                  | 1     | ado.yml (left, spanning the three gate rows)                           |

Code units and the runner are slate, the file is olive, all with white names; the gates are grey with a thick rim.

## Edges

| Edge kind | Count | From → to                                                                                                                                      |
| --------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 5     | Invoke-AdoRestMethod → band top; Pipeline token → invoke-automation.yaml; az CLI → Catzc.Azure.Cli; Pipeline token → ado.yml; az CLI → ado.yml |
| ADR-only  | 1     | PAT → ado.yml (dashed)                                                                                                                         |

Every edge is straight, horizontal or vertical, and none crosses another. The gates have no edges between them.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| slate pill              | runner                     |
| olive page              | file                       |
| grey arrow              | flow: depends on           |
| dashed grey arrow       | ADR-only (no code)         |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-pipe-auth--one-header-function-owns-precedence--architecture.grid.md),
[tree](adr-pipe-auth--one-header-function-owns-precedence--architecture.tree.md) and
[value-chain map](adr-pipe-auth--one-header-function-owns-precedence--architecture.chain.md). A file or ADR lights a minimap when it cites,
or is, the ADR the slide supports (ADR-PIPE-AUTH); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-PIPE-AUTH);
  `docs × .md` (3 files: 2 cite ADR-PIPE-AUTH; 1 is the ADR file of ADR-PIPE-AUTH).
- **Tree** (the repository's files): 3 lit groups, `adr/pipe` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/pipelines/dual-authentication.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `PIPE × ACCESS`, because ADR-PIPE-AUTH: its
  ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and access is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
