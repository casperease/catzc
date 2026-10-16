---
catzc:
  immutable:
    with_body_sha: "3fbd2c7014b2"
    path: docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.md
    folder: docs/.assets/explanation
    name: adr-pipe-auth-what-you-set-decides-the-credential-operations-drawio
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md
      - docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.png
      - docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md
      - docs/.assets/explanation/adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md
      - docs/explanation/pipelines/what-you-set-decides-the-credential.md
---

# What you set decides the credential: the diagram described

```text
A 1572 x 620 diagram, read top to bottom inside one band, WHAT YOU SET.
Glyphs: 3 gates, 1 result, 4 failures; 5 flow edges, 4 failure paths; 8 markers.
Sidebar: world-map grid (2 lit cells), tree (3 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-pipe-auth--what-you-set-decides-the-credential--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/pipelines/what-you-set-decides-the-credential.md).

## At a glance

A 1572 × 620 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band, WHAT YOU SET, with three column headings: RETURNS, YOU SET and YOU SEE. It holds eight glyphs (three gates, one result,
four failures) joined by nine edges, with eight markers and a legend panel along the bottom. The eye lands first on the column of three
gates in the middle; the gate at the bottom is taller than the other two.

## Reading path

1. Marker 1, centre column, top: the gate ExposeAccessToken: true, with a failure path right to marker 2, the failure does not match
   ado.yml.
2. Down to marker 3, the gate $env:AZURE_DEVOPS_PAT, with nothing on its right.
3. Down to marker 4, the gate az login · Connect-AzCli, with three failure paths right to three stacked failures, markers 5, 6 and 7 on
   their right ends: Not logged in to az CLI, set to the wrong context, No ADO token available.
4. Left along the three flow edges to marker 8, the result Authorization header.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                    |
| --------------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| gate                  | 3     | ExposeAccessToken: true, $env:AZURE_DEVOPS_PAT, az login · Connect-AzCli (centre column)                                                 |
| result                | 1     | Authorization header (left column, spanning all three rows)                                                                              |
| failure               | 4     | does not match ado.yml (row 1); Not logged in to az CLI, set to the wrong context, No ADO token available (stacked, row 3), right column |

Gates are grey with a thick rim, the result is green and the failures are red.

## Edges

| Edge kind    | Count | From → to                                                                                                    |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------ |
| flow         | 5     | ExposeAccessToken: true → $env:AZURE_DEVOPS_PAT → az login · Connect-AzCli; each gate → Authorization header |
| failure path | 4     | ExposeAccessToken: true → does not match ado.yml; az login · Connect-AzCli → each of its three failures      |

Every edge is straight, horizontal or vertical, and none crosses another. Two of the failure paths from the gate at the bottom leave from
points on its upper-right and lower-right sides.

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
[world map](adr-pipe-auth--what-you-set-decides-the-credential--operations.grid.md),
[tree](adr-pipe-auth--what-you-set-decides-the-credential--operations.tree.md) and
[value-chain map](adr-pipe-auth--what-you-set-decides-the-credential--operations.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-PIPE-AUTH); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (1 file: 1 cites ADR-PIPE-AUTH);
  `docs × .md` (3 files: 2 cite ADR-PIPE-AUTH; 1 is the ADR file of ADR-PIPE-AUTH).
- **Tree** (the repository's files): 3 lit groups, `adr/pipe` (2 files); `Docs` (1 file); `adr/*` (1 file). The ADR file
  `docs/adr/pipelines/dual-authentication.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `PIPE × ACCESS`, because ADR-PIPE-AUTH: its
  ADR domain `pipelines` sits on the PIPE row (ADR-DSGN-TRACK#14), and access is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-PIPE-AUTH" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
