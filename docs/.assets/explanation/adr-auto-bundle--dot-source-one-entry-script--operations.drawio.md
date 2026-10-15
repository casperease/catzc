---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--dot-source-one-entry-script--operations.drawio.md
    kind: asset-description
    body_sha: ca18a654bc1a
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Dot-source one entry script: the diagram described

```text
A 1572 x 690 diagram, read top to bottom down one column, with a failure glyph to its right.
Glyphs: 5 code units (slate), 1 gate, 1 result, 1 failure; 6 flow edges, 3 failure paths; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (8 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--dot-source-one-entry-script--operations.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/dot-source-one-entry-script.md).

## At a glance

A 1572 × 690 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom down one centred
column inside a full-width band labelled RUN AND SEE, with a tall failure glyph to the column's right. It holds eight glyphs, five code
units, one gate, one result and one failure, joined by nine straight edges, with eight markers and a legend panel along the bottom. The eye
lands first on the tall red failure glyph on the right.

## Reading path

1. Markers 1 and 2, top row: the code units `. ./importer.ps1` and `. Import-Catzc.ps1`, side by side.
2. Down the two edges into marker 3, the code unit Session set-up.
3. Marker 4, the code unit Load; marker 5, on the gate's left point, the gate Run-mode check.
4. Marker 6, the code unit Janitors; marker 7, the result Loaded in N seconds, at the bottom of the column.
5. Marker 8, to the right: the failure Stops with a named error, which three red edges enter from the left.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                             |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------- |
| code unit             | 5     | the two entry scripts (top row); Session set-up, Load, Janitors (column)                          |
| gate                  | 1     | Run-mode check, in the column below Load                                                          |
| result                | 1     | Loaded in N seconds, bottom of the column                                                         |
| failure               | 1     | Stops with a named error, right of the column, level with Session set-up, Load and Run-mode check |

Code units are slate with white names; the result is light green, the failure light red.

## Edges

| Edge kind        | Count | From → to                                                                                                   |
| ---------------- | ----- | ----------------------------------------------------------------------------------------------------------- |
| flow (runs next) | 6     | each entry script → Session set-up; Session set-up → Load → Run-mode check → Janitors → Loaded in N seconds |
| failure path     | 3     | Session set-up, Load and Run-mode check → Stops with a named error                                          |

Every edge is straight: the flow edges vertical, the failure paths horizontal. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| green rounded box       | result                     |
| red rounded box         | failure                    |
| thin grey arrow         | flow: runs next            |
| thin red arrow          | failure path               |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--dot-source-one-entry-script--operations.grid.md),
[tree](adr-auto-bundle--dot-source-one-entry-script--operations.tree.md) and
[value-chain map](adr-auto-bundle--dot-source-one-entry-script--operations.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-BUNDLE); the explanation articles, these descriptions and the drawing tooling never light anything.

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
  (ADR-DSGN-TRACK#15); `AUTO × RELEAS`, because ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and
  build, release is its own value-chain concern (ADR-DSGN-TRACK#15).
- **Lens badge:** OPS, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
