---
catzc:
  derived:
    path: docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "1aa9128178d2"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md
      - docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.png
      - docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md
      - docs/.assets/explanation/adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md
      - docs/explanation/design/drop-a-file-the-import-exports-it.md
---

# Drop a file, and the next import exports it: the diagram described

```text
A 1572 x 702 diagram, read left to right from a tall code unit into two bands.
Glyphs: 3 code units (slate), 2 results, 1 failure, 1 gate; 6 edges; 7 markers.
Sidebar: world-map grid (4 lit cells), tree (6 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/design/drop-a-file-the-import-exports-it.md).

## At a glance

A 1572 × 702 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right. A tall code unit
stands outside the bands on the far left, with a gate below it, and two bands sit to its right: EVERY IMPORT (on top) and WHICH ASPECT
(below). It holds seven glyphs (three code units, two results, one failure and one gate) joined by six edges, with seven markers and a
legend panel along the bottom. The eye lands first on the red failure box in EVERY IMPORT.

## Reading path

1. Marker 1, left of the bands: the code unit Verb-Noun.ps1.
2. Right into EVERY IMPORT: marker 2, the code unit . ./importer.ps1; then marker 3, the result Verb-Noun exported, above marker 4, the
   failure Function name collision(s), reached by the red failure path.
3. Back to the left, along the lower edge into WHICH ASPECT: marker 5, the code unit Get-ModuleGlobSet, then marker 6, the result in
   &lt;kebab&gt;-live.
4. Down from Verb-Noun.ps1 to marker 7, outside the bands: the gate Quality gates.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| code unit             | 3     | Verb-Noun.ps1 (far left, tall), . ./importer.ps1 (EVERY IMPORT), Get-ModuleGlobSet (WHICH ASPECT) |
| result                | 2     | Verb-Noun exported (EVERY IMPORT, right, top), in &lt;kebab&gt;-live (WHICH ASPECT, right)        |
| failure               | 1     | Function name collision(s) (EVERY IMPORT, right, below the result)                                |
| gate                  | 1     | Quality gates (below Verb-Noun.ps1, outside the bands; grey rhombus with a 3 px rim)              |

Code units are slate with white names; results are mint, the failure is red, and the gate is grey.

## Edges

| Edge kind    | Count | From → to                                                                                                                                                                            |
| ------------ | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| flow         | 5     | Verb-Noun.ps1 → . ./importer.ps1, . ./importer.ps1 → Verb-Noun exported, Verb-Noun.ps1 → Get-ModuleGlobSet, Get-ModuleGlobSet → in &lt;kebab&gt;-live, Verb-Noun.ps1 → Quality gates |
| failure path | 1     | . ./importer.ps1 → Function name collision(s)                                                                                                                                        |

Five edges are straight and horizontal, pointing right; the edge into Quality gates points straight down. None crosses another, and none
carries a label.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| mint rounded box        | result                     |
| red rounded box         | failure                    |
| grey rhombus, thick rim | gate                       |
| thin grey arrow         | flow: runs, then yields    |
| thin red arrow          | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.grid.md),
[tree](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.tree.md) and
[value-chain map](adr-dsgn-aspect--drop-a-file-the-import-exports-it--operations.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-DSGN-ASPECT); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 4 lit cells, `automation × .cs` (3 files: 3 cite ADR-DSGN-ASPECT);
  `automation × .ps1` (5 files: 5 cite ADR-DSGN-ASPECT); `automation × .yml` (2 files: 2 cite ADR-DSGN-ASPECT); `docs × .md` (3 files: 2
  cite ADR-DSGN-ASPECT; 1 is the ADR file of ADR-DSGN-ASPECT).
- **Tree** (the repository's files): 6 lit groups, `Globs` (4 files); `Variants` (4 files); `adr/dsgn` (2 files); `Docs` (1 file);
  `QualityGates` (1 file); `adr/*` (1 file). The ADR file `docs/adr/design/module-aspects.md` carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `DSGN × LOCAL`, because ADR-DSGN-ASPECT:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-ASPECT: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-DSGN-ASPECT" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
