---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: "1580340ea555"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.chain.md
      - docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.grid.md
      - docs/.assets/explanation/adr-auto-bundle--build-then-place-with-one-command--operations.tree.md
      - docs/explanation/automation/build-then-place-with-one-command.md
---

# Build, then place with one command: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 5 code units (slate), 1 gate, 1 result, 1 failure; 4 flow edges, 1 failure path; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (8 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--build-then-place-with-one-command--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/build-then-place-with-one-command.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `TARGETS`. It holds eight glyphs (five code units, one gate, one failure and one result)
joined by four flow edges and one failure path, with eight markers and a legend panel along the bottom. Four glyphs sit on one horizontal
line; the failure hangs below the gate, and a thin grey frame in the TARGETS band holds three code units stacked one above the other,
entered by a single edge. The eye lands first on the red failure below the grey rhombus (the gate).

## Reading path

1. Marker 1, SOURCE band: the code unit . ./importer.ps1.
2. Marker 2, BUILD band: the code unit Build-Modules.
3. Marker 3, BUILD band: the gate Assert-CatzcBundle.
4. Marker 4, below it: the failure Catzc build … is invalid, reached by the red failure path from the bottom point of the gate.
5. Marker 5, BUNDLE band: the result Built Catzc 6.6.666.
6. Markers 6, 7 and 8, TARGETS band, top to bottom inside the frame: the code units Install-Catzc -Scope, Export-Catzc -Root and
   Export-Catzc -To nuget.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                                                     |
| --------------------- | ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| code unit             | 5     | . ./importer.ps1 (SOURCE band), Build-Modules (BUILD band), Install-Catzc -Scope, Export-Catzc -Root, Export-Catzc -To nuget (TARGETS band, in the frame) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                                                                                         |
| failure               | 1     | Catzc build … is invalid (BUILD band, below the gate)                                                                                                     |
| result                | 1     | Built Catzc 6.6.666 (BUNDLE band)                                                                                                                         |

The code units are slate with white names; the gate is grey, the result green and the failure red.

## Edges

| Edge kind    | Count | From → to                                                                           |
| ------------ | ----- | ----------------------------------------------------------------------------------- |
| flow         | 4     | . ./importer.ps1 → Build-Modules → Assert-CatzcBundle → Built Catzc 6.6.666 → frame |
| failure path | 1     | Assert-CatzcBundle → Catzc build … is invalid                                       |

Every edge is short and straight: four horizontal on the line, and one red vertical below the gate. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| red rounded box         | failure                           |
| grey arrow              | flow: feeds or runs the next step |
| red arrow               | failure path                      |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--build-then-place-with-one-command--operations.grid.md),
[tree](adr-auto-bundle--build-then-place-with-one-command--operations.tree.md) and
[value-chain map](adr-auto-bundle--build-then-place-with-one-command--operations.chain.md). A file or ADR lights a minimap when it cites, or
is, the ADR the slide supports (ADR-AUTO-BUNDLE); the explanation articles, these descriptions and the drawing tooling never light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 6 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-AUTO-BUNDLE); `automation × .cs` (2 files: 2 cite ADR-AUTO-BUNDLE); `automation × .ps1` (9 files: 9 cite ADR-AUTO-BUNDLE);
  `automation × .yml` (2 files: 2 cite ADR-AUTO-BUNDLE); `docs × .md` (3 files: 2 cite ADR-AUTO-BUNDLE; 1 is the ADR file of
  ADR-AUTO-BUNDLE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to ADR-AUTO-BUNDLE). 1 cell lit only by passing mentions
  shows at 40 % ink.
- **Tree** (the repository's files): 8 lit groups, `Exporter` (10 files); `adr/auto` (2 files); `Root files` (1 file); `.github` (1 file);
  `.internal` (1 file); `Contracts` (1 file); `Docs` (1 file); `adr/*` (1 file). The ADR file `docs/adr/automation/platform-bundle.md`
  carries the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 2 lit cells: `AUTO × BUILD`, because ADR-AUTO-BUNDLE:
  its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern
  (ADR-DSGN-TRACK#15); `AUTO × RELEASE`, because ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and
  build, release is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
