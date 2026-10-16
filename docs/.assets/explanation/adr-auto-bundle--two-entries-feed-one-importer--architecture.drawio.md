---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: "8fc65b2c4d32"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md
      - docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md
      - docs/.assets/explanation/adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md
      - docs/explanation/automation/two-entries-feed-one-importer.md
---

# Two entry scripts feed one importer: the diagram described

```text
A 1572 x 700 diagram, read top to bottom, then left to right, through three bands.
Glyphs: 4 code units (slate), 4 named sets (mauve); 7 edges; 9 markers.
Sidebar: world-map grid (6 lit cells), tree (8 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--two-entries-feed-one-importer--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/two-entries-feed-one-importer.md).

## At a glance

A 1572 × 700 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads top to bottom, then left to
right. A full-width band labelled ENTRY sits above two side-by-side bands, REMOVED AFTER LOAD (left, wider) and STAYS LOADED (right). It
holds eight glyphs, four code units and four named sets, joined by seven straight edges, with nine markers and a legend panel along the
bottom. The eye lands first on the tall code unit Catzc.Internal.Importer, which fills most of the left band.

## Reading path

1. Markers 1 and 2, ENTRY band: the code units importer.ps1 and Import-Catzc.ps1, side by side.
2. Down the two edges into the importer; marker 3 sits beside the edge from Import-Catzc.ps1, rim touching the line, where it crosses the
   gap between the bands.
3. Marker 4, REMOVED AFTER LOAD band: the code unit Catzc.Internal.Importer.
4. Marker 5, the same band: the code unit Catzc.Internal.Bootstrap, to the importer's right, in the third row.
5. Markers 6 to 9, STAYS LOADED band, top to bottom: the named sets `.internal shared layer`, .vendor, Catzc.\* modules and Janitor owners.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                    |
| --------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------ |
| code unit             | 4     | importer.ps1, Import-Catzc.ps1 (ENTRY band); Catzc.Internal.Importer, Catzc.Internal.Bootstrap (REMOVED AFTER LOAD band) |
| named set             | 4     | `.internal shared layer`, .vendor, Catzc.\* modules, Janitor owners (STAYS LOADED band, stacked)                         |

Code units are slate and named sets are mauve, both with white names.

## Edges

| Edge kind              | Count | From → to                                                                                                                                         |
| ---------------------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| thick, to a named set  | 4     | Catzc.Internal.Importer → `.internal shared layer`, → .vendor, → Janitor owners; Catzc.Internal.Bootstrap → Catzc.\* modules                      |
| flow, to one code unit | 3     | importer.ps1 → Catzc.Internal.Importer, Import-Catzc.ps1 → Catzc.Internal.Importer (marker 3), Catzc.Internal.Importer → Catzc.Internal.Bootstrap |

Two edges run straight down from the ENTRY band; the other five run straight right. None crosses another, and none carries a chip.

## Legend

A full-width panel at the bottom of the drawing area, in three columns, left to right:

| Swatch            | Phrase                                     |
| ----------------- | ------------------------------------------ |
| slate rounded box | code unit                                  |
| mauve rounded box | named set                                  |
| thick arrow       | flow: drives, to a named set               |
| thin arrow        | flow: drives, to one code unit             |
| dark disc `1`     | marker: a Walkthrough step                 |
| grey band         | band: in the session after the load or not |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--two-entries-feed-one-importer--architecture.grid.md),
[tree](adr-auto-bundle--two-entries-feed-one-importer--architecture.tree.md) and
[value-chain map](adr-auto-bundle--two-entries-feed-one-importer--architecture.chain.md). A file or ADR lights a minimap when it cites, or
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
- **Lens badge:** ARCH, with "Supports ADR-AUTO-BUNDLE" beneath it.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
