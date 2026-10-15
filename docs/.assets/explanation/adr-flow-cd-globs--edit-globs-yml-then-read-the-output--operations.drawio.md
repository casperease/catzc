---
catzc:
  derived:
    path: docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.md
    kind: asset-description
    body_sha: cd40ba6dd4e8
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md
      - docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.png
      - docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md
      - docs/.assets/explanation/adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md
      - docs/explanation/flow/edit-globs-yml-then-read-the-output.md
---

# Edit globs.yml, then read the output: the diagram described

```text
A 1572 x 560 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 1 gate, 3 code units (slate), 3 results (green); 7 flow edges; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (10 lit groups), value-chain map (1 lit cell), map key.
```

This describes what the [diagram](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/flow/edit-globs-yml-then-read-the-output.md).

## At a glance

A 1572 × 560 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four
bands side by side, labelled YOU EDIT, CONFIG LOAD, YOU RUN and YOU SEE. It holds eight glyphs, one file, one gate, three code units and
three results, joined by seven straight edges, with eight markers and a legend panel along the bottom. The eye lands first on the tall
rhombus in the CONFIG LOAD band, the gate.

## Reading path

1. Marker 1, YOU EDIT band, middle row: the file globs.yml.
2. Along its edge to marker 2, at the top vertex of the gate Config load, a tall rhombus.
3. Along three edges leaving the gate's right side to markers 3, 4 and 5, YOU RUN band, top to bottom: the code units Get-GlobSetTrigger,
   Get-ChangedGlobSet and Test-Automation.
4. Along three edges to markers 6, 7 and 8, YOU SEE band: the results Projected paths, Touched globsets and Skip line.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                  |
| --------------------- | ----- | ---------------------------------------------------------------------- |
| file                  | 1     | globs.yml (YOU EDIT band, middle row)                                  |
| gate                  | 1     | Config load (CONFIG LOAD band, all rows), 3 px rim                     |
| code unit             | 3     | Get-GlobSetTrigger, Get-ChangedGlobSet, Test-Automation (YOU RUN band) |
| result                | 3     | Projected paths, Touched globsets, Skip line (YOU SEE band)            |

The file is olive and the code units are slate, both with white names; the gate is grey and the results light green.

## Edges

| Edge kind | Count | From → to                                                                                                   |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------- |
| flow      | 7     | globs.yml → Config load; Config load → each of the three code units; each code unit → the result in its row |

Every edge is straight and horizontal; none crosses another. The top and bottom edges leave the gate from its slanted sides.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                 | Phrase                     |
| ---------------------- | -------------------------- |
| olive folded page      | file                       |
| grey rhombus, 3 px rim | gate                       |
| slate rounded box      | code unit                  |
| green rounded box      | result                     |
| thin arrow             | flow: feeds, then prints   |
| dark disc `1`          | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.grid.md),
[tree](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.tree.md) and
[value-chain map](adr-flow-cd-globs--edit-globs-yml-then-read-the-output--operations.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-FLOW-CD-GLOBS); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-FLOW-CD-GLOBS); `automation × .cs` (5 files: 5 cite ADR-FLOW-CD-GLOBS); `automation × .ps1` (41 files: 41 cite ADR-FLOW-CD-GLOBS);
  `automation × .yml` (3 files: 3 cite ADR-FLOW-CD-GLOBS); `docs × .md` (5 files: 4 cite ADR-FLOW-CD-GLOBS; 1 is the ADR file of
  ADR-FLOW-CD-GLOBS); `pipelines × .yaml` (6 files: 6 cite ADR-FLOW-CD-GLOBS). 1 cell lit only by passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 10 lit groups, `Globs` (38 files); `pipelines` (6 files); `Az.DevOps.BuildValidation` (5 files);
  `QualityGates` (4 files); `adr/flow` (2 files); `docs` (2 files); `.github` (1 file); `Docs` (1 file); `Exporter` (1 file); `adr/*` (1
  file). The ADR file `docs/adr/flow/durable-sha-globs.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 1 lit cell: `DSGN × LOCAL`, because ADR-FLOW-CD-GLOBS:
  its ADR domain `flow` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-FLOW-CD-GLOBS" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
