---
catzc:
  derived:
    path: docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "4e799212fbed"
    adrs:
      - ADR-DSGN-TRACK#{9,14-16}
    links:
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.png
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md
      - docs/.assets/explanation/adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md
      - docs/explanation/automation/every-code-root-is-a-copy.md
---

# One engine builds, every code root is a copy: the diagram described

```text
A 1572 x 600 diagram, read left to right through four bands.
Glyphs: 1 store (slate), 2 code units (slate), 1 gate, 3 results; 6 flow edges; 8 markers.
Sidebar: world-map grid (7 lit cells), tree (17 lit groups), value-chain map (4 lit cells), map key.
```

This describes what the [diagram](adr-auto-bundle--every-code-root-is-a-copy--architecture.drawio.png) draws, in the vocabulary of the
diagram glyphs; what it means is in [the article](../../explanation/automation/every-code-root-is-a-copy.md).

## At a glance

A 1572 × 600 canvas: a 1300 px drawing area on the left and a 272 px sidebar on the right. The drawing reads left to right through four tall
bands, labelled `SOURCE`, `BUILD`, `BUNDLE` and `CODE ROOTS`. It holds seven glyphs (one store, two code units, one gate and three results)
joined by six flow edges, with eight markers and a legend panel along the bottom. A thin grey frame in the CODE ROOTS band holds two results
stacked one above the other, and a single edge enters the frame. The eye lands first on the grey rhombus (the gate) in the BUILD band.

## Reading path

1. Marker 1, SOURCE band: the store automation/, a cylinder.
2. Along the line to marker 2, BUILD band: the code unit Catzc.Internal.Builder.
3. Marker 3, BUILD band: the gate Assert-CatzcBundle.
4. Marker 4, BUNDLE band: the result Temporary build.
5. Markers 5 and 6, CODE ROOTS band, top to bottom inside the frame: the results Installed and Saved.
6. Marker 7, BUILD band, below the line: the code unit Catzc.Base.Exporter, with an edge up into Catzc.Internal.Builder.
7. Marker 8, just below the returning edge above the bands, which runs from the top of the frame back down into the top of the gate.

## Glyphs

| Glyph (legend phrase) | Count | Where                                                                                        |
| --------------------- | ----- | -------------------------------------------------------------------------------------------- |
| store                 | 1     | automation/ (SOURCE band)                                                                    |
| code unit             | 2     | Catzc.Internal.Builder (BUILD band, on the line), Catzc.Base.Exporter (BUILD band, below it) |
| gate                  | 1     | Assert-CatzcBundle (BUILD band, right), a rhombus with a 3 px rim                            |
| result                | 3     | Temporary build (BUNDLE band), Installed and Saved (CODE ROOTS band, in the frame)           |

The store and the code units are slate with white names; the gate is grey and the results are green.

## Edges

| Edge kind | Count | From → to                                                                                                                                                     |
| --------- | ----- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| flow      | 6     | automation/ → Catzc.Internal.Builder → Assert-CatzcBundle → Temporary build → frame; Catzc.Base.Exporter → Catzc.Internal.Builder; frame → Assert-CatzcBundle |

Five edges are short and straight: four horizontal on the line and one vertical between the two code units. The sixth leaves the top of the
frame, runs left above the bands, and drops into the top point of the gate; it is drawn as three straight segments with one arrowhead. No
edge crosses another.

## Legend

A full-width panel at the bottom of the drawing area, in four columns, left to right:

| Swatch                  | Phrase                            |
| ----------------------- | --------------------------------- |
| slate cylinder          | store                             |
| slate rounded box       | code unit                         |
| grey rhombus, thick rim | gate                              |
| green rounded box       | result                            |
| grey arrow              | flow: feeds or runs the next step |
| dark disc `1`           | marker: a Walkthrough step        |

## Sidebar

The sidebar places the slide on three minimaps. Each has its own description, which gives the reason for every lit cell or group:
[world map](adr-auto-bundle--every-code-root-is-a-copy--architecture.grid.md),
[tree](adr-auto-bundle--every-code-root-is-a-copy--architecture.tree.md) and
[value-chain map](adr-auto-bundle--every-code-root-is-a-copy--architecture.chain.md). A file or ADR lights a minimap when it cites, or is,
the ADR the slide supports (ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); the explanation articles, these descriptions and the drawing tooling never
light anything.

- **World-map grid** (tracks × file languages, ADR-DSGN-TRACK#9): 7 lit cells, `.github × .yml` (1 file, mentions only: 1 cites
  ADR-AUTO-BUNDLE); `automation × .cs` (2 files: 2 cite ADR-AUTO-BUNDLE); `automation × .ps1` (36 files: 36 cite ADR-AUTO-BUNDLE,
  ADR-DSGN-RUNMODE); `automation × .yml` (3 files: 3 cite ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `docs × .md` (5 files: 3 cite ADR-AUTO-BUNDLE,
  ADR-DSGN-RUNMODE; 2 are the ADR file of ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `Root files × .ps1` (1 file: 1 is mapped through files.yml to
  ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE); `Root files × other` (2 files: 2 are mapped through files.yml to ADR-DSGN-RUNMODE). 1 cell lit only by
  passing mentions shows at 40 % ink.
- **Tree** (the repository's files): 17 lit groups, `Exporter` (10 files); `ModuleSystem` (8 files); `QualityGates` (5 files); `TypesSystem`
  (5 files); `Root files` (3 files); `Repository` (3 files); `.internal` (2 files); `Docs` (2 files); `Vendor` (2 files); `adr/auto` (2
  files); `adr/dsgn` (2 files); `.github` (1 file); `ConfigExtensions` (1 file); `Contracts` (1 file); `Globs` (1 file); `RootConfig` (1
  file); `adr/*` (1 file). The ADR files `docs/adr/automation/platform-bundle.md`, `docs/adr/design/run-modes.md` carry the white rim.
- **Value-chain map** (value-chain stack × value-chain concern, ADR-DSGN-TRACK#16): 4 lit cells: `DSGN × LOCAL`, because ADR-DSGN-RUNMODE:
  its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and automation, build is its own value-chain concern
  (ADR-DSGN-TRACK#15); `DSGN × BUILD`, because ADR-DSGN-RUNMODE: its ADR domain `design` sits on the DSGN row (ADR-DSGN-TRACK#14), and
  automation, build is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × BUILD`, because ADR-AUTO-BUNDLE: its ADR domain `automation`
  sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern (ADR-DSGN-TRACK#15); `AUTO × RELEASE`, because
  ADR-AUTO-BUNDLE: its ADR domain `automation` sits on the AUTO row (ADR-DSGN-TRACK#14), and build, release is its own value-chain concern
  (ADR-DSGN-TRACK#15).
- **Lens badge:** ARCH, with "Supports ADR-AUTO-BUNDLE, ADR-DSGN-RUNMODE" beneath it on two lines.
- **Map key:** four swatches (lit, mentions only, lit ADR file, idle) and the code key for the short column labels.
