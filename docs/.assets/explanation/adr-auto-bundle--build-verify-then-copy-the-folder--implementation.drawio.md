---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: c83868699fbf
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md
      - docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md
      - docs/.assets/explanation/adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md
      - docs/explanation/automation/build-verify-then-copy-the-folder.md
---

# Build, verify, then copy the folder: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 file (olive), 4 code units (slate), 1 gate, 1 result; 6 flow edges; 8 markers.
Sidebar: world-map grid (6 lit cells), tree (8 lit groups), value-chain map (2 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.drawio.png) draws, in the vocabulary of
the diagram glyphs; what it means is in [the article](../../explanation/automation/build-verify-then-copy-the-folder.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `TARGETS`. It holds seven glyphs (one file, four code units, one gate and one result) joined
by six flow edges, with eight markers and a legend panel along the bottom. Five glyphs sit on one horizontal line; a thin grey frame in the
TARGETS band holds two more code units stacked one above the other, and a single edge enters the frame. The eye lands first on the grey
rhombus (the gate) at the right end of the BUILD band.

## Reading path

1. Marker 1, SOURCE band: the file exporter.yml, a page with a folded corner.
2. Markers 2 and 3, BUILD band, left to right: the code units Build-Modules and Invoke-ModuleBuild.
3. Marker 4, BUILD band, right: the gate Assert-CatzcBundle.
4. Marker 5, BUNDLE band: the result Catzc/6.6.666/.
5. Markers 6 and 7, TARGETS band, top to bottom inside the frame: the code units Install-Catzc and New-CatzcNuGetPackage.
6. Marker 8, just below the returning edge above the bands, which runs from the top of Install-Catzc back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                                                   |
| --------------------- | ----- | ----------------------------------------------------------------------------------------------------------------------- |
| file                  | 1     | exporter.yml (SOURCE band)                                                                                              |
| code unit             | 4     | Build-Modules and Invoke-ModuleBuild (BUILD band), Install-Catzc and New-CatzcNuGetPackage (TARGETS band, in the frame) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                                                       |
| result                | 1     | Catzc/6.6.666/ (BUNDLE band)                                                                                            |

The file is olive and the code units slate, both with white names; the gate is grey and the result is green.

## Edges

| Edge kind | Count | From → to                                                                                                                           |
| --------- | ----- | ----------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | exporter.yml → Build-Modules → Invoke-ModuleBuild → Assert-CatzcBundle → Catzc/6.6.666/ → frame; Install-Catzc → Assert-CatzcBundle |

The five edges on the line are short, straight and horizontal. The sixth leaves the top of Install-Catzc, runs left above the bands, and
drops into the top point of the gate; it is drawn as three straight segments with one arrowhead. No edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| olive page              | file                              |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| grey arrow              | flow: feeds or runs the next step |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.grid.md),
[tree](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.tree.md) and
[value-chain map](adr-auto-bundle--build-verify-then-copy-the-folder--implementation.chain.md). A file or ADR lights a minimap when it
cites, or is, the ADR the slide supports (ADR-AUTO-BUNDLE); the explanation articles, these descriptions and the drawing tooling never light
anything.

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
