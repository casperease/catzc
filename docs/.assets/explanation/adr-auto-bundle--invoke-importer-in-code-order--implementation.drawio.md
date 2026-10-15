---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.md
    kind: asset-description
    body_sha: "0b78b1119135"
    adrs:
      - ADR-DSGN-TRACK#14
      - ADR-DSGN-TRACK#15
      - ADR-DSGN-TRACK#16
      - ADR-DSGN-TRACK#9
---

# Invoke-Importer in code order: the diagram described

```text
A 1572 x 822 diagram, read top to bottom down one column in one band.
Glyphs: 8 code units (slate), 1 gate; 8 flow edges; 9 markers.
Sidebar: world-map grid (6 lit cells), tree (8 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--invoke-importer-in-code-order--implementation.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/invoke-importer-in-code-order.md).

## At a glance

A 1572 × 822 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom inside one
full-width band labelled CALL ORDER. It holds nine glyphs, eight code units and one gate, joined by eight straight edges, with nine markers
and a legend panel along the bottom. The eye lands first on the wide rhombus, the gate, two-thirds of the way down the column.

## Reading path

1. Marker 1, top of the left column: the code unit importer.ps1.
2. Down the column, markers 2 to 5: the code units Invoke-Importer, Import-InternalModule, Import-VendorModules and Import-AllModules.
3. Marker 6, on the gate's left point: the gate Assert-CatzcRunModeExclusive.
4. Markers 7 and 8: the code units Janitors and Remove-Module.
5. Marker 9, to the right of Invoke-Importer: the code unit Import-Catzc.ps1, whose edge enters Invoke-Importer from the right.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                           |
| --------------------- | ----- | ------------------------------------------------------------------------------- |
| code unit             | 8     | seven in the left column, one (Import-Catzc.ps1) to the right of the second row |
| gate                  | 1     | Assert-CatzcRunModeExclusive, sixth in the left column                          |

Code units are slate with white names; the gate is a light grey rhombus with a thick rim.

## Edges

| Edge kind         | Count | From → to                                                                                               |
| ----------------- | ----- | ------------------------------------------------------------------------------------------------------- |
| flow (calls next) | 8     | seven down the left column, each glyph to the next; one from Import-Catzc.ps1 left into Invoke-Importer |

Every edge is straight; none crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch                  | Phrase                     |
| ----------------------- | -------------------------- |
| slate rounded box       | code unit                  |
| grey rhombus, thick rim | gate                       |
| thin arrow              | flow: calls next           |
| dark disc `1`           | marker: a Walkthrough step |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--invoke-importer-in-code-order--implementation.grid.md),
[tree](adr-auto-bundle--invoke-importer-in-code-order--implementation.tree.md) and
[value-chain map](adr-auto-bundle--invoke-importer-in-code-order--implementation.chain.md). A file or ADR lights a minimap when it cites, or
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
- **Lens badge:** IMPL, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
