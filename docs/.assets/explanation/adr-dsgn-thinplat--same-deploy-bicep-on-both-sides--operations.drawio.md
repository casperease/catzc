---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.md
    kind: asset-description
    body_sha: c95c0447de2a
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md
      - docs/explanation/design/same-deploy-bicep-on-both-sides.md
---

# A developer and a pipeline type the same Deploy-Bicep: the diagram described

```text
A 1572 x 850 diagram, read top to bottom through five bands.
Glyphs: 2 code units, 1 runner (both slate), 2 results, 2 failures; 4 flow edges, 2 failure paths; 7 markers.
Sidebar: world-map grid (2 lit cells), tree (4 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/same-deploy-bicep-on-both-sides.md).

## At a glance

A 1572 × 850 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom through five
full-width bands, labelled CONSUMERS, CLI SURFACE, CATZC, DELEGATED and VENDOR SUBSTRATE. It holds seven glyphs (two code units, one runner,
two results and two failures). Two flow edges enter the wide code unit Deploy-Bicep from above, and four edges leave it downward: two flow
edges to the results and two red failure paths to the failures. Seven markers and a legend panel along the bottom complete it. The eye lands
first on Deploy-Bicep, which spans most of the CLI SURFACE band.

## Reading path

1. Markers 1 and 2, CONSUMERS band: the code unit Connect-AzCli (left) and the runner Mode: azcli (right), each with an edge down.
2. Marker 3, CLI SURFACE band: the code unit Deploy-Bicep.
3. Marker 4, CATZC band, right: the failure subscription target rejected, at the end of a red failure path.
4. Markers 5 and 6, DELEGATED band: the result what-if preview (left) and the failure … failed (az exited N) (right of centre).
5. Marker 7, VENDOR SUBSTRATE band: the result Deployment … succeeded, at the end of the long centre edge.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                    |
| --------------------- | ----- | ------------------------------------------------------------------------ |
| code unit             | 2     | Connect-AzCli (CONSUMERS), Deploy-Bicep (CLI SURFACE)                    |
| runner                | 1     | Mode: azcli (CONSUMERS)                                                  |
| result                | 2     | what-if preview (DELEGATED), Deployment … succeeded (VENDOR SUBSTRATE)   |
| failure               | 2     | subscription target rejected (CATZC), … failed (az exited N) (DELEGATED) |

The code units (rounded boxes) and the runner (a pill) are slate with white names; the results are light green and the failures light red.

## Edges

| Edge kind    | Count | From → to                                                                                                                       |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------- |
| flow         | 4     | Connect-AzCli → Deploy-Bicep, Mode: azcli → Deploy-Bicep, Deploy-Bicep → what-if preview, Deploy-Bicep → Deployment … succeeded |
| failure path | 2     | Deploy-Bicep → subscription target rejected, Deploy-Bicep → … failed (az exited N)                                              |

Every edge is straight and vertical, and none crosses another or a glyph.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| slate pill              | runner                     |
| light-green rounded box | result                     |
| light-red rounded box   | failure                    |
| grey arrow              | flow: then                 |
| red arrow               | failure path               |
| dark disc `1`           | marker: a Walkthrough step |
| grey band               | band: one layer            |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.grid.md),
[tree](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.tree.md) and
[value-chain map](adr-dsgn-thinplat--same-deploy-bicep-on-both-sides--operations.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-THINPLAT); the explanation articles, these descriptions and the drawing tooling never light
anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 2 lit cells, `automation × .yml` (2 files: 2 cite ADR-DSGN-THINPLAT);
  `docs × .md` (3 files: 2 cite ADR-DSGN-THINPLAT; 1 is the ADR file of ADR-DSGN-THINPLAT).
- **Tree** (the repository's files): 4 lit groups, `adr/dsgn` (2 files); `Docs` (1 file); `QualityGates` (1 file); `adr/*` (1 file). The ADR
  file `docs/adr/design/thin-platforms.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-THINPLAT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, deploy is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × DEPLOY`, because ADR-DSGN-THINPLAT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, deploy is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-DSGN-THINPLAT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
