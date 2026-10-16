---
catzc:
  immutable:
    with_body_sha: "136cc22ac14c"
    path: docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.md
    folder: docs/.assets/explanation
    name: adr-pipe-auth-configured-credential-proves-its-org-meta-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md
      - docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.png
      - docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md
      - docs/.assets/explanation/adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md
      - docs/explanation/pipelines/configured-credential-proves-its-org.md
---

# The first configured credential wins: the diagram described

```text
A 1572 x 610 diagram, read top to bottom inside one band, PRECEDENCE.
Glyphs: 3 gates, 1 result, 1 failure; 5 flow edges, 2 failure paths; 5 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-pipe-auth--configured-credential-proves-its-org--meta.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/configured-credential-proves-its-org.md).

## At a glance

A 1572 × 610 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band, PRECEDENCE, with three column headings: RETURNS, FIRST CONFIGURED SOURCE and RAISES. It holds five glyphs (three gates, one
result, one failure) joined by seven edges, with five markers and a legend panel along the bottom. The eye lands first on the column of
three gates in the middle, between a tall result on the left and a tall failure on the right.

## Reading path

1. Marker 1, centre column, top: the gate Pipeline token.
2. Down a flow edge to marker 2, the gate Personal access token, and down again to marker 3, the gate Interactive login.
3. Left along the three flow edges to marker 4, the result Authorization header.
4. Right along the two failure paths, from the gates at the top and the bottom, to marker 5, the failure Own error, no fallback.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                   |
| --------------------- | ----- | --------------------------------------------------------------------------------------- |
| gate                  | 3     | Pipeline token, Personal access token, Interactive login (centre column, top to bottom) |
| result                | 1     | Authorization header (left column, spanning all three rows)                             |
| failure               | 1     | Own error, no fallback (right column, spanning all three rows)                          |

Gates are grey with a thick rim, the result is green and the failure is red.

## Edges

| Edge kind    | Count | From → to                                                                                    |
| ------------ | ----- | -------------------------------------------------------------------------------------------- |
| flow         | 5     | Pipeline token → Personal access token → Interactive login; each gate → Authorization header |
| failure path | 2     | Pipeline token → Own error, no fallback; Interactive login → Own error, no fallback          |

Every edge is straight, horizontal or vertical, and none crosses another. The gate in the middle has no failure path.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| grey rhombus, thick rim | gate                       |
| green rounded box       | result                     |
| red rounded box         | failure                    |
| grey arrow              | flow: what comes next      |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-pipe-auth--configured-credential-proves-its-org--meta.grid.md),
[tree](adr-pipe-auth--configured-credential-proves-its-org--meta.tree.md) and
[value-chain map](adr-pipe-auth--configured-credential-proves-its-org--meta.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-PIPE-AUTH); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-PIPE-AUTH);
  `docs × .md` (3 files: 2 cite ADR-PIPE-AUTH; 1 is the ADR file of ADR-PIPE-AUTH).
- **Tree** (the repository's files): 3 lit groups, `adr/pipe` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/pipelines/dual-authentication.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `PIPE × ACCESS`, because ADR-PIPE-AUTH: its
  ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and access is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** META, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
